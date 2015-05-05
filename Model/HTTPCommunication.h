//
//  HTTPCommunication.h
//  BikeShareApp
//
//  Created by Vincent Renais on 2015-05-04.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

@import Foundation;

@interface HTTPCommunication : NSObject <NSURLSessionDownloadDelegate>

// successBlock will contain the block you're going to call when the request is completed

@property (copy,nonatomic) void (^successBlock)(NSData *);

// Craft and request using NSURLRequest and NSURLConnection

- (void) retrieveURL:(NSURL *)url
        successBlock:(void (^)(NSData *))successBlock;

// Task has finished downloading delegate  method

-(void)URLSession           :(NSURLSession *)session
                downloadTask:(NSURLSessionDownloadTask *)downloadTask
   didFinishDownloadingToURL:(NSURL *)location;

@end
