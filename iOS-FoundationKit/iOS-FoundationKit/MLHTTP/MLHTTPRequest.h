//
//  MLHTTPRequest.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLRequestItem.h"

@interface MLHTTPRequest : NSObject

/**
 ** requestItem 请求消息体
 ** 成功返回
 ** 失败返回
 */
+ (void)requestWithItem:(MLRequestItem *)item
           successBlock:(void (^)(id responseObject))success
           failureBlock:(void (^)(id errorObject))failure;


@end
