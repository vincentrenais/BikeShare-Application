//
//  Station.h
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

@import Foundation;
@import MapKit;

@interface Station : NSObject <MKAnnotation>

@property (strong,nonatomic) NSString *stationName;
@property (strong,nonatomic) NSNumber *availableDocks;
@property (strong,nonatomic) NSNumber *availableBikes;
@property (strong,nonatomic) NSString *statusValue;
@property (strong,nonatomic) NSNumber *location;
@property (strong,nonatomic) NSNumber *latitude;
@property (strong,nonatomic) NSNumber *longitude;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
