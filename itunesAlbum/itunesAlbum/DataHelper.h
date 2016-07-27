//
//  DataHelper.h
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/23/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumCollectionViewCell.h"

@protocol DataHelperDelegate

- (void)onAlbumsLoaded:(NSError *)error;

@end


@interface DataHelper : NSObject

- (instancetype)initWithDelegate:(id<DataHelperDelegate>)delegate;

- (void)searchAlbums:(NSString *)searchKeyword;

- (void)cleanAlbums;

- (NSArray *)loadAlbums;

- (void)loadCellImage:(AlbumCollectionViewCell *)cell withUrl:(NSString *)url;

+ (NSString *)formSearchApi:(NSString *)searchKeyword limit:(int)limit;

@end
