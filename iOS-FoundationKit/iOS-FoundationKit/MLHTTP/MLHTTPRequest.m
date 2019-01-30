//
//  MLHTTPRequest.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLHTTPRequest.h"
#import "Macro.h"

@implementation MLHTTPRequest

+ (void)requestWithItem:(MLRequestItem *)item
           successBlock:(void (^)(id responseObject))success
           failureBlock:(void (^)(id errorObject))failure
{
    NSString *url = [ML_STRING_FORMAT(item.serverUrl) stringByAppendingString:ML_STRING_FORMAT(item.functionPath)];
    NSMutableURLRequest *request = nil;
    if (!item.requestParams) {
        item.requestParams = @{};
    }
    if (!item.headerParams) {
        item.headerParams = @{};
    }
    switch (item.requestMethod) {
        case MLHTTP_GET:
        {
            if (item.requestParams.count > 0) {
                NSString *params = [self toUrlParamString:item.requestParams];
                if ([url containsString:@"?"]) {
                    url = [url stringByAppendingString:params];
                }
                else{
                    url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@",params]];
                }
            }
            //对URL中的中文进行转码
            NSString *encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodeUrl]];
            request.HTTPMethod = @"GET";
        }
            break;
        case MLHTTP_POST:
        default:
        {
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            request.HTTPMethod = @"POST";
            //设置本次请求的数据请求格式
            [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            if (item.requestParams.count > 0) {
                NSData *body = [NSJSONSerialization dataWithJSONObject:item.requestParams options:NSJSONWritingPrettyPrinted error:nil];
                request.HTTPBody = body;
            }
        }
            break;
    }
    request.timeoutInterval = item.timeInterval;
    //请求头信息
    if (item.headerParams.count > 0) {
        NSArray *headerArray = [NSArray arrayWithArray:item.headerParams.allKeys];
        for (NSString *key in headerArray)
        {
            if (key && item.headerParams[key] != nil) {
                [request setValue:ML_STRING_FORMAT(item.headerParams[key]) forHTTPHeaderField:key];
            }
        }
    }
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //默认返回json格式的数据
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(result);
            }else{
                failure(error);
            }
        });
    }];
    [task resume];
}

+ (NSString *)toUrlParamString:(id)jsonObj
{
    NSMutableString *urlParamString = [NSMutableString string];
    if ([jsonObj isKindOfClass:[NSArray class]]) {
        for (id itemObj in jsonObj) {
            if (urlParamString.length>0) {
                [urlParamString appendString:@"&"];
            }
            if([itemObj isKindOfClass:[NSDictionary class]]){
                [urlParamString appendString:[MLHTTPRequest toUrlParamString:itemObj]];
            }else if([itemObj isKindOfClass:[NSArray class]]){
                [urlParamString appendString:[MLHTTPRequest toUrlParamString:itemObj]];
            }else{
                //没有key-value不取
            }
        }
    }
    else{
        NSDictionary *dict = jsonObj;
        NSArray *allKeys = dict.allKeys;
        allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
        }];
        for (NSString *key in allKeys)
        {
            if (urlParamString.length>0)
            {
                [urlParamString appendString:@"&"];
            }
            
            id valueObj = dict[key];
            if([valueObj isKindOfClass:[NSDictionary class]])
            {
                [urlParamString appendString:[MLHTTPRequest toUrlParamString:valueObj]];
            }
            else if([valueObj isKindOfClass:[NSArray class]])
            {
                [urlParamString appendString:[MLHTTPRequest toUrlParamString:valueObj]];
            }
            else
            {
                NSString *keyUrlEncode = [NSString stringWithFormat:@"%@",key];
                NSString *valueUrlEncode = [NSString stringWithFormat:@"%@",valueObj];
                [urlParamString appendFormat:@"%@=%@",keyUrlEncode,valueUrlEncode];
            }
        }
    }
    return urlParamString;
}

@end
