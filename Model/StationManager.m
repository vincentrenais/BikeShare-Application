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

-(void)requestURL
{

    
    self.http = [[HTTPCommunication alloc]init];
    
    NSURL *url = [NSURL URLWithString:BASE_URL];

    [self.http retrieveURL:url successBlock:^(NSData *response)
     
     {
         NSError *error = nil;
         
         // Deserialized the information we get from the API
         
         NSDictionary *stationsListJSON = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
         
         if (!error)
         {
             NSArray *results = [stationsListJSON objectForKey:@"stationBeanList"];
             
             self.arrayOfStations = [[NSMutableArray alloc]init];
             
             for (NSDictionary *dicts in results)
             {
                 NSNumber *stationID = dicts[@"id"];
                 NSString *stationName = dicts[@"stationName"];
                 NSNumber *availableDocks = dicts[@"availableDocks"];
                 NSNumber *latitude = dicts[@"latitude"];
                 NSNumber *longitude = dicts[@"longitude"];
                 NSString *statusValue = dicts[@"statusValue"];
                 NSNumber *availableBikes = dicts[@"availableBikes"];
                 
                 NSDictionary *dict = @{@"stationID" : stationID,
                                    @"stationName" : stationName,
                                    @"availableDocks" : availableDocks,
                                    @"latitude" : latitude,
                                    @"longitude" : longitude,
                                    @"statusValue" : statusValue,
                                    @"availableBikes" : availableBikes};
             
                 [self.arrayOfStations addObject:dict];
                 NSLog(@"%@",self.arrayOfStations);
             }
             
         }
     }];
    
}
@end
