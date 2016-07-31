//
//  AlbumCollectionViewCell.m
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/24/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import "AlbumCollectionViewCell.h"
#import "Thumbnail.h"

#define DATA_KEYPATH @"data"

@interface AlbumCollectionViewCell()

@property (nonatomic) Thumbnail *thumbnail;

@end

@implementation AlbumCollectionViewCell

- (void)populateCellWithThumbnail:(Thumbnail *)thumbnail {
    if (thumbnail.data) {
        UIImage *image = [UIImage imageWithData:thumbnail.data];
        [self.thumbnailImageView setImage:image];
    } else {
        [thumbnail addObserver:self forKeyPath:DATA_KEYPATH options:NSKeyValueObservingOptionNew context:nil];
        self.thumbnail = thumbnail;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:DATA_KEYPATH] && object == self.thumbnail) {
        NSData *data = [change objectForKey:NSKeyValueChangeNewKey];
        if (data) {
            [self.thumbnail removeObserver:self forKeyPath:DATA_KEYPATH];
            self.thumbnail = nil;
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.thumbnailImageView setImage:image];
            });
        }
    }
}

- (void)dealloc {
    if (_thumbnail) {
        [_thumbnail removeObserver:self forKeyPath:DATA_KEYPATH];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.thumbnailImageView setImage:nil];
}

@end
