//
//  MLAFHTTPRequest.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/15.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLRequestItem.h"

/**
 *  AFNetworking封装一层，便于业务使用
 */
@interface MLAFHTTPRequest : NSObject

/**
 * requestItem 请求消息体
 * 成功返回
 * 失败返回
 */
+ (void)requestItem:(MLRequestItem *)item
       successBlock:(void (^)(id responseObject))success
       failureBlock:(void (^)(id errorObject))failure;


@end
