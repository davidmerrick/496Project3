//
//  CameraViewController.m
//  496Project3
//
//  Based on code found at http://www.techotopia.com/index.php/An_Example_iOS_7_iPhone_Camera_Application
//
//  Created by David Merrick on 2/12/14.
//  Copyright (c) 2014 David Merrick. All rights reserved.
//
// This handles the camera view
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

@synthesize library;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.library = [[ALAssetsLibrary alloc] init];
}

- (void)viewDidUnload
{
    self.library = nil;
    [super viewDidUnload];
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
        if (_newMedia){
            
            // Save the images to a special album called "TestGallery" for demonstration purposes
            
            NSString *albumName = @"TestGallery";
            //Find the album
            __block ALAssetsGroup* groupToAddTo;
            [self.library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                    //@todo: if album doesn't exist, create it
                    if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
                        // If album exists, put it in our group block
                        groupToAddTo = group;
                    }
            }
            failureBlock:^(NSError* error) {
                NSLog(@"failed to enumerate albums:\nError: %@", [error localizedDescription]);
            }];
            
            //Save the image to the album
            CGImageRef img = [image CGImage];
            [self.library writeImageToSavedPhotosAlbum:img metadata:[info objectForKey:UIImagePickerControllerMediaMetadata] completionBlock:^(NSURL* assetURL, NSError* error) {
                    if (error.code == 0) {
                        NSLog(@"saved image completed:\nurl: %@", assetURL);
                        // Try to get the asset
                        [self.library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                            // Add the photo to the album
                            [groupToAddTo addAsset:asset];
                            NSLog(@"Added %@ to %@", [[asset defaultRepresentation] filename], albumName);
                        }
                        failureBlock:^(NSError* error) {
                            NSLog(@"failed to retrieve image asset:\nError: %@ ", [error localizedDescription]);
                        }];
                    } else {
                        NSLog(@"saved image failed.\nerror code %i\n%@", error.code, [error localizedDescription]);
                    }
            }];
            //reference: http://stackoverflow.com/questions/10954380/save-photos-to-custom-album-in-iphones-photo-library
        }
    }
}

// Callback method for if it finished saving but there were errors
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
    //This tells the delegate that the user canceled the operation
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
