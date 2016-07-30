//
//  DataHelper.h
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/23/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumCollectionViewCell.h"

@class Album;
@class Thumbnail;

@protocol DataHelperDelegate

- (void)onAlbumsLoaded:(NSError *)error;

@end


@interface DataHelper : NSObject

@property (nonatomic, readonly) NSArray<Album *> *albums;

- (instancetype)initWithDelegate:(id<DataHelperDelegate>)delegate;

- (void)searchAlbums:(NSString *)searchKeyword;

- (void)cleanAlbums;

- (void)preloadIfNecessary:(int)row;

- (Thumbnail *)thumbnailByAlbum:(Album *)album;

+ (NSString *)formSearchApi:(NSString *)searchKeyword limit:(int)limit;

@end
