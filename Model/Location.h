//
//  Location.h
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-06.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

@import Foundation;
@import MapKit;


@interface Location : NSObject <MKAnnotation>

@property (strong,nonatomic) NSNumber *location;
@property (strong,nonatomic) NSNumber *latitude;
@property (strong,nonatomic) NSNumber *longitude;

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
