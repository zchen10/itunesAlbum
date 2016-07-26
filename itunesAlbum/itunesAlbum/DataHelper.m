//
//  DataHelper.m
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/23/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import "DataHelper.h"
#import "AppDelegate.h"
#import "Album.h"

#define SEARCH_TEMPLATE @"https://itunes.apple.com/search?limit=20&term="
#define ALBUM_ENTITY @"Album"
#define RESULTS_KEY @"results"

@interface DataHelper()<NSURLConnectionDelegate>

@property (nonatomic, weak) id<DataHelperDelegate> delegate;
@property (nonatomic) NSURLSessionDataTask *downloadTask;
@property (nonatomic, weak) AppDelegate *appDelegate;
@end

@implementation DataHelper

- (instancetype)initWithDelegate:(id<DataHelperDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _appDelegate = [UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)searchAlbums:(NSString *)searchKeyword {
    if (self.downloadTask) {
        [self.downloadTask cancel];
        self.downloadTask = nil;
    }
    
    [self cleanAlbums];
    NSString *escapedWord =
        [searchKeyword stringByReplacingOccurrencesOfString:@" +"
                                                 withString:@"+"
                                                    options:NSRegularExpressionSearch
                                                      range:NSMakeRange(0, searchKeyword.length)];
    NSString *searchUrl = [SEARCH_TEMPLATE stringByAppendingString:escapedWord];
    NSLog(@"Search url is %@", searchUrl);

    self.downloadTask =
        [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:searchUrl]
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        if (!error) {
                                            NSDictionary *dict = [NSJSONSerialization
                                                           JSONObjectWithData:data
                                                           options:kNilOptions
                                                           error:&error];
                                            [self saveAlbums:dict];
                                        }
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.delegate onAlbumsLoaded:error];
                                        });
                                        }];
    
    [self.downloadTask resume];
}

- (void)loadCellImage:(AlbumCollectionViewCell *)cell withUrl:(NSString *)url {
   NSURLSessionDataTask *task =
    [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                    if (!error) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [cell.thumbnailImageView setImage:[UIImage imageWithData:data]];
                                        });
                                    }
                                }];
    [task resume];
}

- (void)cleanAlbums {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:ALBUM_ENTITY];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    [self.appDelegate.persistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];

}

- (void)saveAlbums:(NSDictionary *)json {
    NSArray *propertyNames = nil;
    NSArray *results = [json objectForKey:RESULTS_KEY];
    for (NSDictionary *dict in results) {
        Album *album =
            [NSEntityDescription insertNewObjectForEntityForName:ALBUM_ENTITY inManagedObjectContext:self.appDelegate.managedObjectContext];
        if (!propertyNames) {
            propertyNames = album.entity.propertiesByName.allKeys;
        }
        for (NSString *key in propertyNames) {
            [album setValue:[dict objectForKey:key] forKey:key];
        }
    }
}

- (NSArray *)loadAlbums {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:ALBUM_ENTITY];
    NSError *error = nil;
    return [self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

@end
