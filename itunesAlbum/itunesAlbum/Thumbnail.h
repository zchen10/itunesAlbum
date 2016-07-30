//
//  Thumbnail.h
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/29/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Thumbnail : NSManagedObject

@property (nonatomic, strong) NSString *artworkUrl100;
@property (nonatomic, strong) NSData *data;

+ (void)loadArtwork:(Thumbnail *)thumbnail;

@end
