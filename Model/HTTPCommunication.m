//
//  HTTPCommunication.m
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

#import "HTTPCommunication.h"

@implementation HTTPCommunication

- (void) retrieveURL:(NSURL *)url successBlock:(void (^)(NSData *))successBlock
{
    // Persisting given successBlock for calling later
    self.successBlock = successBlock;
    
    // Creating the request using the given URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    // Set the default configuration
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Set up a session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    
    // Preparing the download task
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    // Establish the connection
    [task resume];
}



-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    // Getting the download data from the local storage
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    // Ensure that you call the successBlock for the main thread by using the dispatch
    dispatch_async(dispatch_get_main_queue(), ^{ self.successBlock(data); });
        // Calling the block stored before as a callback
    

}


@end
