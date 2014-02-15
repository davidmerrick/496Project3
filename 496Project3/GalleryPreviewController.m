//
//  GalleryPreviewController.m
//  496Project3
//
//  Created by David Merrick on 2/15/14.
//  Copyright (c) 2014 David Merrick. All rights reserved.
//

#import "GalleryPreviewController.h"

@implementation GalleryPreviewController



-(void) viewDidLoad
{
    //set the image preview
    self.imagePreview.image = self.image;
}

- (IBAction)closePreview:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
