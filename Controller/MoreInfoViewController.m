//
//  MoreInfoViewController.m
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//



#import "MoreInfoViewController.h"
#import "StationManager.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MoreInfoViewController ()

@property (nonatomic) CLLocation *currentLocation;

@end

@implementation MoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    [self getCurrentLocation];

}

- (void)getCurrentLocation {
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    NSLog(@"didUpdateToLocation: %@", newLocation);
}


-(void)viewDidAppear:(BOOL)animated
{
    [[StationManager sharedList] requestURLWithSuccess:^(NSMutableArray *array)
     {
         self.arrayOfStations = array;
         
         for (Station *station in self.arrayOfStations)
         {
             station.distance = [self.currentLocation distanceFromLocation:station.location];
         
             [self.arrayOfStations addObject:station];
         }

         NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Station.distance" ascending:YES];
         [self.arrayOfStations sortedArrayUsingDescriptors:@[sortDescriptor]];
         
         NSLog(@"%@",self.arrayOfStations[0]);
         
         
         Station *station = [[Station alloc]init];
         
         UILabel *stationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 100, 200, 50)];
         stationNameLabel.text = station.stationName;
         stationNameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
         [self.view addSubview:stationNameLabel];
         
         UILabel *availableDocksLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 160, 200, 50)];
         availableDocksLabel.text = [station.availableDocks stringValue];
         availableDocksLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
         [self.view addSubview:availableDocksLabel];
         
         UILabel *availableBikesLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 220, 200, 50)];
         availableBikesLabel.text = [station.availableBikes stringValue];
         availableBikesLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
         [self.view addSubview:availableBikesLabel];
         
     }
                                               failure:^(NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"alert" message:@"It didn't work!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"ok", nil];
         [alert show];
     }];
}

@end
