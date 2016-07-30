//
//  Thumbnail.m
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/29/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import "Thumbnail.h"

@implementation Thumbnail

@dynamic artworkUrl100;
@dynamic data;

+ (void)loadArtwork:(Thumbnail *)thumbnail {
    // download the image data
    NSURLSessionDataTask *task =
    [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:thumbnail.artworkUrl100]
                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                    if (!error) {
                                        thumbnail.data = data;
                                    }
                                }];
    [task resume];
}
@end
