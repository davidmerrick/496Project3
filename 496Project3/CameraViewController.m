//
//  CameraViewController.m
//  496Project3
//
//  Based on code found at http://www.techotopia.com/index.php/An_Example_iOS_7_iPhone_Camera_Application
//
//  Created by David Merrick on 2/12/14.
//  Copyright (c) 2014 David Merrick. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // if kUTTypeImage (photo, not video), save it to photos album
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _imageView.image = image;
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:didFinishSavingWithError:contextInfo:),
                                           nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Image save failed."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)useCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;

        // Set the camera to be the source for picking images from
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];

        //Keep it simple and don't allow users to edit photos before they're passed to the app
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = YES;
    }
}
@end
