//
//  SecondViewController.m
//  496Project3
//
//  Based on code from http://brandontreb.com/iphone-programming-tutorial-creating-an-image-gallery-like-over-part-1
//
//  Created by David Merrick on 2/12/14.
//  Copyright (c) 2014 David Merrick. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "GalleryViewController.h"
#import "GalleryPreviewController.h"
#import "PhotoCell.h"

@interface GalleryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) NSArray *assets;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, weak) IBOutlet UIImageView *bigPhotoView;
@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    // 1
    ALAssetsLibrary *assetsLibrary = [GalleryViewController defaultAssetsLibrary];
    // 2
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result)
            {
                // 3
                [tmpAssets addObject:result];
            }
        }];
        
        // 4
        //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        //self.assets = [tmpAssets sortedArrayUsingDescriptors:@[sort]];
        self.assets = tmpAssets;
        
        // 5
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - collection view data source

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    ALAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    //Colors the background red in the event of no images. Don't really need this now.
    //cell.backgroundColor = [UIColor redColor];
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PhotoCell *preview = (PhotoCell *) sender;
    ALAsset *asset = preview.asset;
    
    //Get the full-size image
    ALAssetRepresentation* representation = [asset defaultRepresentation];
    UIImage* image = [UIImage imageWithCGImage:[representation fullResolutionImage]];
    
    // Set the imagePreview to this in our galleryPreviewController
    GalleryPreviewController* dest = (GalleryPreviewController *) (segue.destinationViewController);
    dest.image = image;
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

@end
