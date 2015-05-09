//
//  ClosestStationVC.m
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

@import QuartzCore;

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


- (void)viewDidLoad
{
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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25, 270, 330, 50)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
    label.text = @"The closest station is:";
    [self.view addSubview:label];
    
    
    self.stationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 310, 330, 50)];
    self.stationNameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:40];
    [self.view addSubview:self.stationNameLabel];
    
    self.availableBikesLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 390, 330, 50)];
    self.availableBikesLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:23];
    [self.view addSubview:self.availableBikesLabel];
    
    self.availableDocksLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 440, 330, 50)];
    self.availableDocksLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:23];
    [self.view addSubview:self.availableDocksLabel];
    
    UIButton *turnByTurnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    turnByTurnButton.frame = CGRectMake(25, 530, 330, 50);
    turnByTurnButton.layer.borderWidth = 1.0f;
    turnByTurnButton.layer.borderColor = [UIColor grayColor].CGColor;
    turnByTurnButton.layer.cornerRadius = 7.0f;
    turnByTurnButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
    [turnByTurnButton setTitle:@"Turn-by-turn directions" forState:UIControlStateNormal];
    [turnByTurnButton addTarget:self action:@selector(callMapsApp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:turnByTurnButton];
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
         self.stationNameLabel.text = closestStation.stationName;
         self.availableBikesLabel.text = [NSString stringWithFormat:@"Bikes available: %@",[closestStation.availableBikes stringValue]];
         self.availableDocksLabel.text = [NSString stringWithFormat:@"Docks available: %@",[closestStation.availableDocks stringValue]];
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

- (void)callMapsApp
{
    Station *closestStation = [[Station alloc]init];
    closestStation = self.arrayOfStations[0];
    CLLocationCoordinate2D annotation = closestStation.coordinate;
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:annotation addressDictionary:nil];
    MKMapItem *destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
}

#pragma - delegate methods


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
}

@end
