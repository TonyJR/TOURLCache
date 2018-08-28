//
//  TOURLCacheProtocol.m
//  TOURLCache
//
//  Created by TonyJR on 2018/4/23.
//  Copyright © 2018年 Uchuban. All rights reserved.
//

#import "TOURLCacheProtocol.h"
#import "TOURLCacheHeader.h"
#import "TOURLSessionDelegate.h"


static NSSet *_supportedSchemes;
static NSSet *_supportedHosts;
static NSURLCache *_cache;

@interface TOURLCacheProtocol ()
{
    TOURLSessionDelegate *_sessionDelegate;
}
@property (nonatomic,strong) NSURLSessionDataTask *dataTask;
@property (nonatomic,readonly) TOURLSessionDelegate *sessionDelegate;

@end


@implementation TOURLCacheProtocol


#pragma mark - Getter & Setter

+ (void)setSupportedSchemes:(NSSet *)supportedSchemes{
    @synchronized(self){
        _supportedSchemes = supportedSchemes;
    }
}

+ (NSSet *)supportedSchemes{
    @synchronized(self){
        if (!_supportedSchemes) {
            _supportedSchemes = [NSSet setWithObjects:@"http",@"https",nil];
        }
        return _supportedSchemes;
    }
}


+ (void)setSupportedHosts:(NSSet *)hosts{
    _supportedHosts = hosts;
}

+ (NSSet *)supportedHosts{
    return _supportedHosts;
}

+ (NSURLCache *)cache{
    if (!_cache) {
        _cache = [[NSURLCache alloc] initWithMemoryCapacity:10 *1024 * 1024 diskCapacity:100 * 1024 * 1024 diskPath:nil];
    }
    return _cache;
}

+ (void)setCache:(NSURLCache *)cache{
    _cache = cache;
}

- (TOURLSessionDelegate *)sessionDelegate{
    if (!_sessionDelegate) {
        _sessionDelegate = [TOURLSessionDelegate new];
    }
    return _sessionDelegate;
}

#pragma mark - Override
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([[request.HTTPMethod uppercaseString] isEqualToString:@"GET"]) {
        if ([[self supportedSchemes] containsObject:[[request URL] scheme]])
        {
            if (![self supportedHosts] || [[self supportedHosts] containsObject:[request URL].host]) {
                if ([request valueForHTTPHeaderField:TOURLCacheHeader] == nil) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setValue:@"" forHTTPHeaderField:TOURLCacheHeader];
    return mutableRequest;
}


- (void)startLoading{
    NSURLCache *cache = [[self class] cache];
    NSCachedURLResponse *cachedResponse =[cache cachedResponseForRequest:self.request];
    
    if (cachedResponse) {
        [[self client] URLProtocol:self didReceiveResponse:cachedResponse.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];  // We cache ourselves.
        [[self client] URLProtocol:self didLoadData:cachedResponse.data];
        [[self client] URLProtocolDidFinishLoading:self];
    }else{
        [self loadRequest];
    }
}

- (void)loadRequest{
    
    static NSURLSession *session;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:config delegate:self.sessionDelegate delegateQueue:nil];
    });
    
    self.dataTask = [session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [[self client] URLProtocol:self didFailWithError:error];
        }else{
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (httpResponse.statusCode == 200) {
                    [[[self class] cache] storeCachedResponse:[[NSCachedURLResponse alloc] initWithResponse:response data:data]
                                    forRequest:self.request];
                    
                }
            }
            [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];  // We cache ourselves.
            [[self client] URLProtocol:self didLoadData:data];
            [[self client] URLProtocolDidFinishLoading:self];
        }
    }];
    
    [self.dataTask resume];
}

- (void)stopLoading{
    [self.dataTask cancel];
}

- (void)dealloc{
    
}

@end
