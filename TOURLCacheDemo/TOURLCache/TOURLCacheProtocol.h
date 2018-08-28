//
//  TOURLCacheProtocol.h
//  TOURLCache
//
//  Created by TonyJR on 2018/4/23.
//  Copyright © 2018年 Uchuban. All rights reserved.
//
/*
 TOURLCacheProtocol
 */

#import <Foundation/Foundation.h>

@interface TOURLCacheProtocol : NSURLProtocol

//支持的scheme，默认支持http、https协议
+ (NSSet *)supportedSchemes;
+ (void)setSupportedSchemes:(NSSet *)supportedSchemes;

//缓存支持的域名，默认为nil全网支持
+ (NSSet *)supportedHosts;
+ (void)setSupportedHosts:(NSSet *)hosts;

//缓存
+ (NSURLCache *)cache;
+ (void)setCache:(NSURLCache *)cache;
@end
