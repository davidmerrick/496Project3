//
//  MapViewController.m
//  496Project3
//
//  Created by David Merrick on 2/14/14.
//  Copyright (c) 2014 David Merrick. All rights reserved.
//
// Based on code found at: http://www.raywenderlich.com/30001/overlay-images-and-overlay-views-with-mapkit-tutorial
// and http://www.raywenderlich.com/21365/introduction-to-mapkit-in-ios-6-tutorial

#import <AssetsLibrary/AssetsLibrary.h>
#import "MyLocation.h"
#import "MapViewController.h"

#define METERS_PER_MILE 1609.344

@implementation MapViewController 


-(void) viewDidLoad
{
    // Set the center of the map to be in the center of OR
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 44.0564;
    zoomLocation.longitude= -121.3081;
    
    // Set the bounds for the view (300 miles by 300 miles)
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 300*METERS_PER_MILE, 300*METERS_PER_MILE);
    [_mapView setRegion:viewRegion animated:YES];
    
    // Overlay the photos
    [self plotPhotoPositions];
}


- (void)plotPhotoPositions
{
    _assets = [@[] mutableCopy];
    
    // Grab our static instance of the ALAssetsLibrary
    ALAssetsLibrary *assetsLibrary = [MapViewController defaultAssetsLibrary];
    
    // Enumerate through all of the ALAssets (photos) in the user’s Asset Groups (Folders)
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result)
            {
                // Enumerate each folder and add its images
                CLLocation *location = [result valueForProperty:ALAssetPropertyLocation];
                
                //Ignore ones with no lat or long set
                //@TODO: change this. Can have lat long of 0 0?
                if(!(location.coordinate.latitude == 0 && location.coordinate.longitude == 0)){
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = location.coordinate.latitude;
                    coordinate.longitude = location.coordinate.longitude;

                    UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                    
                    // Create the annotation with our data
                    MyLocation *annotation = [[MyLocation alloc] initWithName:@"Image" image:image coordinate:coordinate];
                    [_mapView addAnnotation:annotation];
                }
            }
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[(MyLocation *) annotation image]];
            [annotationView addSubview:imageView];
            
            //Set the frame size
            CGRect frame = annotationView.frame;
            
            frame.size = CGSizeMake(imageView.frame.size.width/4.0, imageView.frame.size.height/4.0);
            annotationView.frame = imageView.frame = frame;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    
    return nil;
}

+ (ALAssetsLibrary *) defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}
     
@end
