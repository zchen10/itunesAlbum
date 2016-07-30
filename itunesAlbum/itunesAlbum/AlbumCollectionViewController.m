//
//  AlbumCollectionViewController.m
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/23/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import "AlbumCollectionViewController.h"
#import "AlbumCollectionViewCell.h"
#import "Album.h"
#import "DataHelper.h"


@interface AlbumCollectionViewController ()<UITextFieldDelegate, DataHelperDelegate>

@property (nonatomic) UIActivityIndicatorView *loadingView;
@property (nonatomic) DataHelper *dataLoader;

@end

@implementation AlbumCollectionViewController

static NSString * const reuseIdentifier = @"AlbumCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[AlbumCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.dataLoader = [[DataHelper alloc] initWithDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataLoader.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Album *album = [self.dataLoader.albums objectAtIndex:indexPath.row];
    Thumbnail *thumbnail = [self.dataLoader thumbnailByAlbum:album];
    [cell populateCellWithThumbnail:thumbnail];
    [self.dataLoader preloadIfNecessary:indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark <UITextFieldDelgate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // show spin wheel
    if (!self.loadingView) {
        self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    [textField addSubview:self.loadingView];
    self.loadingView.frame = textField.bounds;
    [self.loadingView startAnimating];
    
    [self.collectionView reloadData];
    [self.dataLoader searchAlbums:textField.text];
    return YES;
}

#pragma mark
- (void)onAlbumsLoaded:(NSError *)error {
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
    
    if (error) {
        //handle error here.
    } else {
        [self.collectionView reloadData];
    }
}

@end
