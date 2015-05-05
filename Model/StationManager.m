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


-(void)requestURL
{
    self.http = [[HTTPCommunication alloc]init];
    self.station = [[Station alloc]init];
    self.arrayOfStations = [[NSMutableArray alloc]init];
    
    NSURL *url = [NSURL URLWithString:BASE_URL];

    [self.http retrieveURL:url successBlock:^(NSData *response)
     
     {
         NSError *error = nil;
         
         // Deserialized the information we get from the API
         
         NSDictionary *stationsListJSON = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
         
         if (!error)
         {
             NSArray *results = [stationsListJSON objectForKey:@"stationBeanList"];
             
             for (NSDictionary *dicts in results)
             {
                 self.station.stationID = dicts[@"id"];
                 self.station.stationName = dicts[@"stationName"];
                 self.station.availableDocks = dicts[@"availableDocks"];
                 self.station.latitude = dicts[@"latitude"];
                 self.station.longitude = dicts[@"longitude"];
                 self.station.statusValue = dicts[@"statusValue"];
                 self.station.availableBikes = dicts[@"availableBikes"];
                 
                 NSDictionary *dict = @{@"stationID" : self.station.stationID,
                                    @"stationName" : self.station.stationName,
                                    @"availableDocks" : self.station.availableDocks,
                                    @"latitude" : self.station.latitude,
                                    @"longitude" : self.station.longitude,
                                    @"statusValue" : self.station.statusValue,
                                    @"availableBikes" : self.station.availableBikes};
                 
                 
                 [[StationManager sharedList].arrayOfStations addObject:dict];
             }
             NSLog(@"%@",[StationManager sharedList].arrayOfStations);
         }
     }];
}
@end
