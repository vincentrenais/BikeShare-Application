//
//  MoreInfoViewController.m
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import "MoreInfoViewController.h"

@implementation MoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    UILabel *stationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 100, 200, 50)];
    stationNameLabel.text = @"Station Name";
    stationNameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
    [self.view addSubview:stationNameLabel];
    
    UILabel *availableDocksLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 160, 200, 50)];
    availableDocksLabel.text = @"Docks available";
    availableDocksLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
    [self.view addSubview:availableDocksLabel];
    
    UILabel *availableBikesLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 220, 200, 50)];
    availableBikesLabel.text = @"Bikes available";
    availableBikesLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
    [self.view addSubview:availableBikesLabel];
    
}

@end
