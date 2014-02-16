//
//  FirstViewController.h
//  496Project3
//
//  Created by David Merrick on 2/12/14.
//  Copyright (c) 2014 David Merrick. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraViewController : UIViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property BOOL newMedia;
@property (strong, atomic) ALAssetsLibrary* library;

//Displays a preview of the image after it's taken in the view
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//ImagePicker from Camera
- (IBAction)useCamera:(id)sender;
@end
