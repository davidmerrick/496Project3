//
//  myLocation.h
//  496Project3
//
//  Created by David Merrick on 2/15/14.
//  Copyright (c) 2014 David Merrick. All rights reserved.
//
// Based on code from http://www.raywenderlich.com/21365/introduction-to-mapkit-in-ios-6-tutorial
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name image:(UIImage*)image coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end