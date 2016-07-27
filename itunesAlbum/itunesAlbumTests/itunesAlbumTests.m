//
//  itunesAlbumTests.m
//  itunesAlbumTests
//
//  Created by Zhihui CHEN on 7/23/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DataHelper.h"
#import "AppDelegate.h"

@interface itunesAlbumTests : XCTestCase

@end

@implementation itunesAlbumTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFormApi {
    NSString *key = @"aaa bbb";
    int limit = 20;
    NSString *api = [DataHelper formSearchApi:key limit:limit];
    
    XCTAssertTrue([api isEqualToString:@"https://itunes.apple.com/search?term=aaa+bbb&limi=20"]);
    
    key = @"a   b cd";
    limit = 100;
    api = [DataHelper formSearchApi:key limit:limit];
    XCTAssertTrue([api isEqualToString:@"https://itunes.apple.com/search?term=a+b+cd&limi=100"]);
}

- (void)testLoadAlbum {
    DataHelper *dataHelper = [[DataHelper alloc] initWithDelegate:nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSArray *albums = [dataHelper loadAlbums];
    XCTAssertTrue(albums.count == 1);
    
    [dataHelper cleanAlbums];
    albums = [dataHelper loadAlbums];
    XCTAssertTrue(albums.count == 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
