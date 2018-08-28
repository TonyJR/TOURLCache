//
//  TOURLSessionDelegate.m
//  TOURLCache
//
//  Created by TonyJR on 2018/4/24.
//  Copyright © 2018年 TonyJR. All rights reserved.
//

#import "TOURLSessionDelegate.h"
#import "TOURLCacheHeader.h"

@implementation TOURLSessionDelegate

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error{
    
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler{
    
    NSMutableURLRequest *newRequest = [request mutableCopy];
    [newRequest setValue:nil forHTTPHeaderField:TOURLCacheHeader];
    completionHandler(newRequest);
}


@end
