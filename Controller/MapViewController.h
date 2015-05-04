//
//  MapViewController.h
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

@import UIKit;
@import MapKit;
@import CoreLocation;

#import "Station.h"
#import "StationManager.h"


@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>

@property (strong,nonatomic) MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;

@property (strong,nonatomic) NSMutableArray *arrayOfStations;

@end
