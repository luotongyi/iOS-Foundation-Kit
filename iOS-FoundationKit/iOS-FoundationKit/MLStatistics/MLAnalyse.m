//
//  MLAnalyse.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLAnalyse.h"
#import "MLHookURLSession.h"
#import "MLInstance.h"

#define ML_PROTOCOL_KEY     @"ML_SessionProtocol_Key"

@interface MLAnalyse()<NSURLSessionDelegate>

@property (nonatomic,copy)  NSURLSession *session;

@property (nonatomic,copy)  NSOperationQueue *queue;

@property (nonatomic,copy)  NSURLSessionTask *task;

@end

@implementation MLAnalyse

// 开始监听
+ (void)startMonitor
{
    Class cls = NSClassFromString(@"WKBrowsingContextController");
    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
    if (cls && sel) {
        if ([(id)cls respondsToSelector:sel]) {
            [(id)cls performSelector:sel withObject:ML_RULE_HTTP];
            [(id)cls performSelector:sel withObject:ML_RULE_HTTPS];
        }
    }
    [MLHookURLSession hookSessionConfiguration];
    [NSURLProtocol registerClass:[MLAnalyse class]];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSString *url = request.URL.absoluteString;
    if ([url hasPrefix:ML_RULE_HTTP] || [url hasPrefix:ML_RULE_HTTPS]) {
        if ([NSURLProtocol propertyForKey:ML_PROTOCOL_KEY inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSMutableURLRequest *mutableReq = [request mutableCopy];
    return mutableReq;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSMutableURLRequest *request = [self.request mutableCopy];
    [NSURLProtocol setProperty:@(YES) forKey:ML_PROTOCOL_KEY inRequest:request];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:self.queue];
    self.task = [self.session dataTaskWithRequest:request];
    [self.task resume];
}

- (void)stopLoading
{
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

#pragma -mark -NSURLSessionDelegate
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if ([[MLInstance sharedInstance].registerKey length] > 0) {
        NSString *urlString = [task.response.URL.absoluteString lowercaseString];
        NSString *statusCode = [NSString stringWithFormat:@"%ld",(long)((NSHTTPURLResponse *)task.response).statusCode];
        
        if ([urlString containsString:@".js"] ||
            [urlString containsString:@".css"] ||
            [urlString containsString:@".gif"] ||
            [urlString containsString:@".png"] ||
            [urlString containsString:@".jpg"] ||
            [urlString containsString:@".svg"] ||
            [urlString containsString:@".jpeg"]) {
        }
        else{
            ML_INFORMATION_LOG(@"%@----%@",statusCode,urlString);
            
#warning 接口信息数据库插入
            
        
            
        }
    }
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    }
    else{
        [self.client URLProtocolDidFinishLoading:self];
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    completionHandler(proposedResponse);
}

//TODO: 重定向
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSMutableURLRequest *redirectRequest = [newRequest mutableCopy];
    [self.task cancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
    
    [[self class] removePropertyForKey:ML_PROTOCOL_KEY inRequest:redirectRequest];
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
}


@end
