//
//  StationManager.h
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Station.h"
#import "HTTPCommunication.h"

@interface StationManager : NSObject

@property (strong,nonatomic) HTTPCommunication *http;
@property (strong,nonatomic) NSNumber *responseID;
@property (strong,nonatomic) NSMutableArray *arrayOfStations;

-(void)requestURL;

@end
