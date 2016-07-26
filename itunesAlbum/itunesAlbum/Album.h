//
//  Album.h
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/25/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Album : NSManagedObject

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *artworkUrl100;
@property (nonatomic, strong) NSNumber *collectionId;
@property (nonatomic, strong) NSString *collectionName;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *previewUrl;
@property (nonatomic, strong) NSNumber *trackId;
@property (nonatomic, strong) NSString *trackName;
@property (nonatomic, strong) NSNumber *trackNumber;
@property (nonatomic, strong) NSNumber *trackTimeMillis;
@property (nonatomic, strong) NSString *wrapperType;

@end
