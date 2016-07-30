//
//  AlbumCollectionViewCell.h
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/24/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Thumbnail;

@interface AlbumCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImageView;

- (void)populateCellWithThumbnail:(Thumbnail *)thumbnail;

@end
