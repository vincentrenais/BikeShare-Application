//
//  MoreInfoViewController.h
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

@import UIKit;
@import CoreLocation;

#import "Station.h"

@interface MoreInfoViewController : UIViewController <CLLocationManagerDelegate>

@property (strong,nonatomic) NSMutableArray *arrayOfStations;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end
