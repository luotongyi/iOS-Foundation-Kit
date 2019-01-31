//
//  MLInstance.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ML_INFORMATION_LOG( format, ... )  \
                 if ([MLInstance sharedInstance].enableLog) { \
                     NSLog( @"<%@:(%d)> %@", \
                     [[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
                     __LINE__, [NSString stringWithFormat:(format), \
                     ##__VA_ARGS__] ); \
                 }else{}

@interface MLInstance : NSObject

//注册时的key，只有当校验成功才赋值
@property (nonatomic, copy  )   NSString *registerKey;

//是否开启Log日志，默认NO
@property (nonatomic, assign)   BOOL enableLog;

/**
 *  @brief MLInstance单例
 *  @return MLInstance对象
 */
+ (instancetype)sharedInstance;


@end
