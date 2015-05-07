//
//  MapViewController.m
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import "MapViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation MapViewController
{
    MKRoute *routeDetails;
//    MKPlacemark *placemark;
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
        [self.locationManager requestAlwaysAuthorization];
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
//            placemark = [[MKPlacemark alloc] initWithCoordinate:station.coordinate addressDictionary:nil];
//            NSLog(@"%@",placemark);
//            myAnnotation.coordinate = CLLocationCoordinate2DMake([station.latitude doubleValue], [station.longitude doubleValue]);
            myAnnotation.title = station.stationName;
            myAnnotation.subtitle = [NSString stringWithFormat:@"Bikes: %@ - Docks: %@", station.availableBikes, station.availableDocks];
            [self.mapView addAnnotation:myAnnotation];
        
        }
    }
                                               failure:^(NSError *error)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"alert" message:@"It didn't work!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"ok", nil];
        [alert show];
    }];
    
    
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.02f, 0.02f)) animated:YES];
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
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"bikeshare_pin.png"];
            //pinView.calloutOffset = CGPointMake(0, 32);
        } else {
            pinView.annotation = annotation;
        }
        
        // Add a detail disclosure button to the callout.
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [rightButton addTarget:self action:@selector(routeToStation:) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        
        
        // Add an image to the left callout.
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bikeshare_pin.png"]];
        pinView.leftCalloutAccessoryView = iconView;
        
        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"SELECT");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [mapView removeOverlay:routeDetails.polyline];
    
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
            routeDetails = response.routes.lastObject;
            [mapView addOverlay:routeDetails.polyline];
        }
    }];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
}



@end
