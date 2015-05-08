//
//  StationManager.h
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

@import Foundation;
@import CoreLocation;


#import "Station.h"
#import "HTTPCommunication.h"


@interface StationManager : HTTPCommunication

@property (strong,nonatomic) NSMutableArray *arrayOfStations;

+ (instancetype)sharedList;

- (void)requestURLWithSuccess:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure;

@end
