//
//  AlbumCollectionViewController.m
//  itunesAlbum
//
//  Created by Zhihui CHEN on 7/23/16.
//  Copyright © 2016 edsonchen. All rights reserved.
//

#import "AlbumCollectionViewController.h"
#import "HttpHelper.h"

@interface AlbumCollectionViewController ()<UITextFieldDelegate, HttpHelperDelegate>

@property (nonatomic) UIActivityIndicatorView *loadingView;
@property (nonatomic) HttpHelper *dataLoader;

@end

@implementation AlbumCollectionViewController

static NSString * const reuseIdentifier = @"AlbumCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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
    NSInteger count = [[self.dataLoader.albums objectForKey:@"resultCount"] integerValue];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blackColor];
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
    
    // start searching
    if (!self.dataLoader) {
        self.dataLoader = [[HttpHelper alloc] initWithDelegate:self];
    }
    [self.dataLoader searchAlbums:textField.text];
    return YES;
}

#pragma mark
- (void)onResponse:(NSError *)error {
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
    
    if (error) {
        //handle error here.
    } else {
        [self.collectionView reloadData];
    }
}

@end
