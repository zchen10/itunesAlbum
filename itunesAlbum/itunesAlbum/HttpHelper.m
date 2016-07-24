//
//  HttpHelper.m
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/23/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import "HttpHelper.h"

#define SEARCH_TEMPLATE @"https://itunes.apple.com/search?term=%@"

@interface HttpHelper()<NSURLConnectionDelegate>

@property (nonatomic, weak) id<HttpHelperDelegate> delegate;
@property (nonatomic) NSURLSessionDataTask *downloadTask;

@end

@implementation HttpHelper

- (instancetype)initWithDelegate:(id<HttpHelperDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)searchAlbums:(NSString *)searchKeyword {
    if (self.downloadTask) {
        [self.downloadTask cancel];
        self.downloadTask = nil;
    }
    
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
                                        if (error) {
                                            [self.delegate onResponse:error];
                                            return;
                                        }
                                        NSError* jsonError = nil;
                                        self.albums = [NSJSONSerialization
                                                              JSONObjectWithData:data
                                                              options:kNilOptions 
                                                              error:&jsonError];
                                        [self.delegate onResponse:jsonError];
                                          }];
    
    [self.downloadTask resume];
}

@end
