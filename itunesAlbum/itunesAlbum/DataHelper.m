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
#import "Thumbnail.h"

#define SEARCH_TEMPLATE @"https://itunes.apple.com/search?term=%@&limit=%d"
#define ALBUM_ENTITY @"Album"
#define THUMBNAIL_ENTITY @"Thumbnail"

#define RESULTS_KEY @"results"
#define SEARCH_LIMIT 200
#define PRELOAD_PAGE_SIZE 40

@interface DataHelper()<NSURLConnectionDelegate>

@property (nonatomic, weak) id<DataHelperDelegate> delegate;
@property (nonatomic) NSURLSessionDataTask *downloadTask;
@property (nonatomic, weak) AppDelegate *appDelegate;
@property (nonatomic) NSMutableDictionary *cachedThumbnails;


@property int preloadCount;

@end

@implementation DataHelper

@synthesize albums = _albums;

- (instancetype)initWithDelegate:(id<DataHelperDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _appDelegate = [UIApplication sharedApplication].delegate;
        _cachedThumbnails = [NSMutableDictionary new];
        _albums = nil;
        [self loadCachedAlbumsAndThumbnails];
    }
    return self;
}

- (void)searchAlbums:(NSString *)searchKeyword {
    [self cleanAlbums];
    self.preloadCount = 0;
    
    if (self.downloadTask) {
        [self.downloadTask cancel];
        self.downloadTask = nil;
    }
    
    NSString *searchUrl = [DataHelper formSearchApi:searchKeyword limit:SEARCH_LIMIT];
   
    self.downloadTask =
        [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:searchUrl]
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        if (!error) {
                                            NSDictionary *dict = [NSJSONSerialization
                                                           JSONObjectWithData:data
                                                           options:kNilOptions
                                                           error:&error];
                                            [self cacheAlbums:dict];
                                        }
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.delegate onAlbumsLoaded:error];
                                        });
                                        }];
    
    [self.downloadTask resume];
}

- (void)cleanAlbums {
    _albums = nil;
    [self.cachedThumbnails removeAllObjects];
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    [context reset];
}

- (void)preloadIfNecessary:(int)row {
    if (self.preloadCount >= self.albums.count || self.preloadCount > row + PRELOAD_PAGE_SIZE) {
        return;
    }
    
    int newPreloadCount = MIN(self.albums.count, MAX(row, self.preloadCount) + PRELOAD_PAGE_SIZE);
    for (int i = self.preloadCount; i < newPreloadCount; ++i) {
        Album *album = [self.albums objectAtIndex:i];
        Thumbnail *thumbnail = [self.cachedThumbnails objectForKey:album.artworkUrl100];
        if (!thumbnail) {
            thumbnail =
                [NSEntityDescription insertNewObjectForEntityForName:THUMBNAIL_ENTITY inManagedObjectContext:self.appDelegate.managedObjectContext];
            thumbnail.artworkUrl100 = album.artworkUrl100;
            [self.cachedThumbnails setObject:thumbnail forKey:thumbnail.artworkUrl100];
            [Thumbnail loadArtwork:thumbnail];
        }
    }
    self.preloadCount = newPreloadCount;
}

- (Thumbnail *)thumbnailByAlbum:(Album *)album {
    NSString *artworkUrl = album.artworkUrl100;
    Thumbnail *thumbnail = nil;
    if (artworkUrl.length > 0) {
        thumbnail = [self.cachedThumbnails objectForKey:artworkUrl];
        if (!thumbnail) {
            thumbnail =
                [NSEntityDescription insertNewObjectForEntityForName:THUMBNAIL_ENTITY inManagedObjectContext:self.appDelegate.managedObjectContext];
            [self.cachedThumbnails setObject:thumbnail forKey:artworkUrl];
        }
    }
    return thumbnail;
}


- (void)cacheAlbums:(NSDictionary *)json {
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
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:ALBUM_ENTITY];
    NSError *error = nil;
    _albums = [self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [self preloadIfNecessary:PRELOAD_PAGE_SIZE];
}

- (void)loadCachedAlbumsAndThumbnails {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:THUMBNAIL_ENTITY];
    NSError *error = nil;
    NSArray *thumbnails = [self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (Thumbnail *thumbnail in thumbnails) {
        [self.cachedThumbnails setObject:thumbnail forKey:thumbnail.artworkUrl100];
    }
    
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:ALBUM_ENTITY];
    _albums = [self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

+ (NSString *)formSearchApi:(NSString *)searchKeyword limit:(int)limit {
    searchKeyword =
    [searchKeyword stringByReplacingOccurrencesOfString:@" +"
                                             withString:@"+"
                                                options:NSRegularExpressionSearch
                                                  range:NSMakeRange(0, searchKeyword.length)];
    return [NSString stringWithFormat:SEARCH_TEMPLATE, searchKeyword, limit];
}

@end
