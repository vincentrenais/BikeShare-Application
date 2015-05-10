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
    
    // Checking for iOS 8 and asking to access user location
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Gets the user's current location.
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    // ImageView with the logo.
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toronto_circle_logo"]];
    imageView.frame = CGRectMake(110, 100, 150, 150);
    [self.view addSubview:imageView];
    
    
    // Closest station label.
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(22, 270, 330, 50)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
    label.text = @"The closest station is:";
    [self.view addSubview:label];
    
    // Station name label.
    self.stationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 310, 330, 50)];
    self.stationNameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:35];
    [self.view addSubview:self.stationNameLabel];
    
    // Available bikes label.
    self.availableBikesLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 390, 330, 50)];
    self.availableBikesLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:23];
    [self.view addSubview:self.availableBikesLabel];
    
    // Available docks label.
    self.availableDocksLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 440, 330, 50)];
    self.availableDocksLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:23];
    [self.view addSubview:self.availableDocksLabel];
    
    
    // Turn-by-turn directions button.
    UIButton *turnByTurnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    turnByTurnButton.frame = CGRectMake(22, 530, 330, 50);
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
    
    // The following piece of code takes the array from the API, modify each object by adding the distance property (between the user current location and each station), then sort the array ascendingly based on the distance property. Finaly the VC shows the first index of the array which is the smallest distance therefore the closest station.
    
    [[StationManager sharedList] requestURLWithSuccess:^(NSMutableArray *array)
     {
         self.arrayOfStations = array;
         
         Station *station = [[Station alloc]init];
         
         for(int i = 0; i < self.arrayOfStations.count; i++)
         {
             station = [self.arrayOfStations objectAtIndex:i];
             station.distance = [self.currentLocation distanceFromLocation:station.location];
         }
         
         // Sort the array so the index O is the smallest distance.
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
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"alert" message:@"The stations' coordinates could not be retreived!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"ok", nil];
         [alert show];
     }];
}


// This method open Maps with the coordinates for the closest station.
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
