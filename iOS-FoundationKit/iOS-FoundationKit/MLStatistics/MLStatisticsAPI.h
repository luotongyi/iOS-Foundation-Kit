//
//  MLStatisticsAPI.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLStatisticsAPI : NSObject

/**
 *  @brief 开启Log日志，默认NO
 */
+ (void)setLogEnable:(BOOL)enable;

/**
 *  @brief 注册APP的key，不能为nil、null，
 */
+ (void)registerKey:(NSString *)key;

@end
