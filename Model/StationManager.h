//
//  StationManager.h
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

@import Foundation;

#import "Station.h"
#import "HTTPCommunication.h"

@interface StationManager : HTTPCommunication


@property (strong,nonatomic) NSMutableArray *arrayOfStations;

- (void)requestURLWithSuccess:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure;

+ (instancetype)sharedList;

@end
