//
//  MapViewController.m
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import "MapViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MapViewController ()

@property (strong,nonatomic) NSMutableArray *arrayOfStations;

@end

@implementation MapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:_mapView];
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [[StationManager sharedList] requestURLWithSuccess:^(NSMutableArray *array)
     {
         self.arrayOfStations = array;
         NSLog(@"%@",self.arrayOfStations);
     } failure:^(NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"alert" message:@"It didn't work!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"ok", nil];
         [alert show];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
