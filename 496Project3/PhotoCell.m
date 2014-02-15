//
//  PhotoCell.m
//  496Project3
//
//  Created by David Merrick on 2/14/14.
//  Copyright (c) 2014 David Merrick. All rights reserved.
//
//  Based on code found at http://brandontreb.com/iphone-programming-tutorial-creating-an-image-gallery-like-over-part-2

#import "PhotoCell.h"

@interface PhotoCell ()
//an IBOutlet to a UIImageView that we will create inside of the Storyboard
@property(nonatomic, weak) IBOutlet UIImageView *photoImageView;
@end

@implementation PhotoCell
- (void) setAsset:(ALAsset *)asset
{
    //Overwriting the setter method for the asset to convert
    //the asset’s thumbnail into UIImage and set it to contents of UIImageView
    _asset = asset;
    self.photoImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
}
@end
