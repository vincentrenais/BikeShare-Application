//
//  ClosestStationVC.m
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//



#import "ClosestStationVC.h"
#import "StationManager.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface ClosestStationVC ()

@property (nonatomic) CLLocation *currentLocation;

@end



@implementation ClosestStationVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Closest Station";
        self.tabBarItem.image = [UIImage imageNamed:@"closest_station_tab_icon"];
    }
    return self;
}


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
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toronto_circle_logo"]];
    imageView.frame = CGRectMake(110, 100, 150, 150);
    [self.view addSubview:imageView];
}


-(void)viewDidAppear:(BOOL)animated
{
    [[StationManager sharedList] requestURLWithSuccess:^(NSMutableArray *array)
     {
         self.arrayOfStations = array;
         Station *station = [[Station alloc]init];
         
         for(int i = 0; i < self.arrayOfStations.count; i++)
         {
             station = [self.arrayOfStations objectAtIndex:i];
             station.distance = [self.currentLocation distanceFromLocation:station.location];
         }
         
         NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
         
         [self.arrayOfStations sortUsingDescriptors:@[sortDescriptor]];
         
         Station *closestStation = [[Station alloc]init];
         
         closestStation = self.arrayOfStations[0];
         
         UILabel *stationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 300, 330, 50)];
         stationNameLabel.text = closestStation.stationName;
         stationNameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:30];
         [self.view addSubview:stationNameLabel];
         
         UILabel *availableBikesLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 400, 330, 50)];
         availableBikesLabel.text = [NSString stringWithFormat:@"Bikes available: %@",[closestStation.availableBikes stringValue]];
         availableBikesLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
         [self.view addSubview:availableBikesLabel];
         
         UILabel *availableDocksLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 450, 330, 50)];
         availableDocksLabel.text = [NSString stringWithFormat:@"Docks available: %@",[closestStation.availableDocks stringValue]];
         availableDocksLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
         [self.view addSubview:availableDocksLabel];
     }
                                               failure:^(NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"alert" message:@"It didn't work!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"ok", nil];
         [alert show];
     }];
}

- (void)getCurrentLocation {
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
}



#pragma delegate methods


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
}



@end
