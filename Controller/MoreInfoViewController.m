//
//  MoreInfoViewController.m
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import "MoreInfoViewController.h"

@interface MoreInfoViewController ()

@end

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
