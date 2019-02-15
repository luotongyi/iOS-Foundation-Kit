//
//  MLAFHTTPRequest.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/15.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLAFHTTPRequest.h"
//#import "AFNetworking.h"

@implementation MLAFHTTPRequest

+ (void)requestItem:(MLRequestItem *)item
       successBlock:(void (^)(id responseObject))success
       failureBlock:(void (^)(id errorObject))failure
{
    if (item.showDialog) {
        //请求等待框
        
    }
    NSString *urlPath = [item.serverUrl stringByAppendingString:item.functionPath];
//    AFHTTPSessionManager *_afsm = [AFHTTPSessionManager manager];
//    _afsm.requestSerializer = [AFJSONRequestSerializer serializer];
//    _afsm.responseSerializer = [AFHTTPResponseSerializer serializer];
//    _afsm.requestSerializer.timeoutInterval = 15;
    
    if (item.headerParams.count > 0)
    {
        NSArray *cookieKey = item.headerParams.allKeys;
        for (NSString *key in cookieKey)
        {
//            [_afsm.requestSerializer setValue:item.headerParams[key] forHTTPHeaderField:key];
        }
    }
    switch (item.requestMethod) {
        case MLHTTP_GET:
        {
//            [_afsm GET:urlPath parameters:item.requestParams progress:^(NSProgress * _Nonnull uploadProgress) {
//
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                success(responseObject);
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                failure(error);
//            }];
        }
            break;
        case MLHTTP_POST:
        default:
        {
//            [_afsm POST:urlPath parameters:item.requestParams progress:^(NSProgress * _Nonnull uploadProgress) {
//
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                success(responseObject);
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                failure(error);
//            }];
        }
            break;
    }
}

@end
