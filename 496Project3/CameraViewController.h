//
//  FirstViewController.h
//  496Project3
//
//  Created by David Merrick on 2/12/14.
//  Copyright (c) 2014 David Merrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraViewController : UIViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
@property BOOL newMedia;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)useCamera:(id)sender;

- (IBAction)useCameraRoll:(id)sender;

@end
