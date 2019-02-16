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
 * 加解密未封装在此方法里，需要加解密的时候可以自己创建request，再通过AFNetworking发起请求
 * 成功返回
 * 失败返回
 */
+ (void)requestItem:(MLRequestItem *)item
       successBlock:(void (^)(id responseObject))success
       failureBlock:(void (^)(id errorObject))failure;


@end
