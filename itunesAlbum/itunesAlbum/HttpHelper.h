//
//  HttpHelper.h
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/23/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumCollectionViewCell.h"

@protocol HttpHelperDelegate

- (void)onResponse:(NSError *)error;

@end


@interface HttpHelper : NSObject

@property (nonatomic) NSDictionary *albums;

- (instancetype)initWithDelegate:(id<HttpHelperDelegate>)delegate;

- (void)searchAlbums:(NSString *)searchKeyword;

- (void)loadCellImage:(AlbumCollectionViewCell *)cell withUrl:(NSString *)url;

@end
