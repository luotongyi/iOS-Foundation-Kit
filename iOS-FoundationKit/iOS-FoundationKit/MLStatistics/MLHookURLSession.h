//
//  MLHookURLSession.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLHookURLSession : NSObject

/**
 *  hook网络请求框架的SessionConfiguration（AFNetworking）
 */
+ (void)hookSessionConfiguration;

@end
