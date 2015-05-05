//
//  StationManager.m
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import "StationManager.h"

#define BASE_URL @"http://www.bikesharetoronto.com/stations/json"

@implementation StationManager

+ (instancetype)sharedList
{
    static StationManager  *stationList = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        stationList = [[StationManager alloc] init];
    });
    return stationList;
}


-(void)requestURLWithSuccess:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure
{
    //self.station = [[Station alloc]init];
    self.arrayOfStations = [[NSMutableArray alloc]init];
    
    NSURL *url = [NSURL URLWithString:BASE_URL];

    [self retrieveURL:url successBlock:^(NSData *response)
    
     {
         NSError *error = nil;
         
         // Deserialized the information we get from the API
         
         NSDictionary *stationsListJSON = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
         
         if (!error)
         {
             NSArray *results = [stationsListJSON objectForKey:@"stationBeanList"];
             
             //[[StationManager sharedList].arrayOfStations removeAllObjects];
             
             for (NSDictionary *dicts in results)
             {
                 Station *station = [[Station alloc]init];
                 
                 station.stationID = dicts[@"id"];
                 station.stationName = dicts[@"stationName"];
                 station.availableDocks = dicts[@"availableDocks"];
                 station.latitude = dicts[@"latitude"];
                 station.longitude = dicts[@"longitude"];
                 station.statusValue = dicts[@"statusValue"];
                 station.availableBikes = dicts[@"availableBikes"];
                 
                 [[StationManager sharedList].arrayOfStations addObject:station];
             }
             if (success)
             {
//                 dispatch_sync(dispatch_get_main_queue(), ^{
                     success([StationManager sharedList].arrayOfStations);
//                 });
                 
                 return;
             }
         }
         else
         {
             if (failure)
             {
//                 dispatch_sync(dispatch_get_main_queue(), ^{
                     success([StationManager sharedList].arrayOfStations);
//                 });
             }
             failure(error);
             return;
         
         }
     }];
    
    return;
}



@end
