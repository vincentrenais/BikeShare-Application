//
//  MapVC.m
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import "MapVC.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface MapVC ()

@property MKRoute *routeDetails;

@end


@implementation MapVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Stations Map";
        self.tabBarItem.image = [UIImage imageNamed:@"map_tab_icon"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:_mapView];
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
//        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
}


-(void)viewDidAppear:(BOOL)animated
{
    [[StationManager sharedList] requestURLWithSuccess:^(NSMutableArray *array)
    {
        self.arrayOfStations = array;
        
        for (Station *station in self.arrayOfStations) {
            MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
            myAnnotation.coordinate = station.coordinate;
            myAnnotation.title = @"<- Turn by turn - Route ->";
            station.stationName = [station.stationName substringToIndex:15];
            myAnnotation.subtitle = [NSString stringWithFormat:@"%@... - %@ bikes - %@ docks", station.stationName, station.availableBikes, station.availableDocks];
            [self.mapView addAnnotation:myAnnotation];
        }
    }
                                               failure:^(NSError *error)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"alert" message:@"It didn't work!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"ok", nil];
        [alert show];
    }];
}

- (void)CallMapsApp
{
    id<MKAnnotation> annotation = [self.mapView.selectedAnnotations firstObject];
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:annotation.coordinate addressDictionary:nil];
    MKMapItem *destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
    
}

#pragma delegate methods


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
       [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01f, 0.01f)) animated:YES];
    });
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // The following creates a pin view if an existing pin view was not available.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"bikeshare_pin.png"];
            //pinView.calloutOffset = CGPointMake(0, 32);
        } else {
            pinView.annotation = annotation;
        }
        
        // Add a button to the callout.
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
        
        // Add an image on the left.
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"turn_by_turn.png"]];
        pinView.leftCalloutAccessoryView = iconView;
        iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CallMapsApp)];
        [iconView addGestureRecognizer:reg];
        
        return pinView;
    }
    return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [mapView removeOverlay:self.routeDetails.polyline];
    id<MKAnnotation> annotation = view.annotation;
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:annotation.coordinate addressDictionary:nil];
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placeMark]];
    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error)
        {
            NSLog(@"Error %@", error.description);
        }
        else
        {
            self.routeDetails = response.routes.lastObject;
            [mapView addOverlay:self.routeDetails.polyline];
        }
    }];
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:self.routeDetails.polyline];
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
}

@end
