//
//  MLCrashHandler.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLCrashHandler : NSObject

/**
 *  @brief 监听Crash信息，每次闪退后插入本地数据库
 **/
void MLUncaughtExceptionHandler(NSException *exception);

@end
