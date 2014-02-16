//
//  SecondViewController.m
//  496Project3
//
//  Based on code from http://brandontreb.com/iphone-programming-tutorial-creating-an-image-gallery-like-over-part-1
//
// Reference for information about ALAssets: http://www.fiveminutes.eu/accessing-photo-library-using-assets-library-framework-on-iphone/
//
//  Created by David Merrick on 2/12/14.
//  Copyright (c) 2014 David Merrick. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "GalleryViewController.h"
#import "GalleryPreviewController.h"
#import "PhotoCell.h"

@interface GalleryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

//This array holds all the photos
@property(nonatomic, strong) NSArray *assets;

//This collection view displays thumbnails of all the photos
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];

    // Grab our static instance of the ALAssetsLibrary
    // This is the block that we will use to enumerate all asset groups
    ALAssetsLibrary *assetsLibrary = [GalleryViewController defaultAssetsLibrary];
    
    // Enumerate through all of the ALAssets (photos) in the user’s Asset Groups (Folders)
    // Note: the ^ operator is used to declare a block variable and to indicate the beginning of a block literal.
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            //Only enumerate images in "TestGallery" album
            if ([[group valueForProperty:ALAssetsGroupPropertyName]
                 isEqualToString:@"TestGallery"]){
                if(result)
                {
                    // Enumerate each folder and add its ALAssets (photos) to the temporary array
                    [tmpAssets addObject:result];
                }
            }
        }];
        
        // Set the assets property to this tmpAssets array
        self.assets = tmpAssets;
        
        // Reload UICollectionView
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        // Display the error to the console
        NSLog(@"Error loading images %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Get rid of any resources that can be recreated
}

// Static method that creates a static instance of ALAssetsLibrary.
// Is necessary so assets don't get released immediately after we enumerate them.
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
    // Determine the number of items needed in the collection view
    return self.assets.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //This sets up the photos in the cells
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    ALAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    return cell;
}

// This method handles displaying the image previews when a user taps one of them in the collection view
// It "segues" to the next view and passes the image contained in the tapped PhotoCell into that view
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

// This sets up the line spacing for items in the collectionView
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

// This sets up the spacing between items in the collectionView
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

@end
