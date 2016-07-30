//
//  AlbumCollectionViewCell.m
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/24/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import "AlbumCollectionViewCell.h"
#import "Thumbnail.h"

@implementation AlbumCollectionViewCell

- (void)populateCellWithThumbnail:(Thumbnail *)thumbnail {
    if (thumbnail.data) {
        UIImage *image = [UIImage imageWithData:thumbnail.data];
        [self.thumbnailImageView setImage:image];
    } else {
        // add KVO.
    }
}

@end
