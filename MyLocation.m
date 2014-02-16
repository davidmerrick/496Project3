//
//  MyLocation.m
//  496Project3
//
//  Created by David Merrick on 2/15/14.
//  Copyright (c) 2014 David Merrick. All rights reserved.
//
// Based on code from http://www.raywenderlich.com/21365/introduction-to-mapkit-in-ios-6-tutorial
//

#import "MyLocation.h"
#import <AddressBook/AddressBook.h>

@interface MyLocation ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end

@implementation MyLocation


//@TODO: Make the GPS coordinates be the subtitles of the image
- (id)initWithName:(NSString*)name image:(UIImage*)image coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown charge";
        }
        self.image = image;
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return @"Image";
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    // Initialize a placemark with the coordinate and a null addressDictionary
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end