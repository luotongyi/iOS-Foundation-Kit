//
//  MLCrashHandler.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLCrashHandler.h"

@implementation MLCrashHandler

void MLUncaughtExceptionHandler(NSException *exception)
{
    NSArray *stackArray = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    //数据库主键
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970]*1000)];
    
    NSMutableDictionary *crashInfo = [NSMutableDictionary dictionary];
    [crashInfo setObject:timeSp forKey:@"crashTime"];
    [crashInfo setObject:name forKey:@"crashName"];
    [crashInfo setObject:reason forKey:@"crashReason"];
    [crashInfo setObject:[stackArray componentsJoinedByString:@"\n"] forKey:@"crashStack"];
    
    //插入数据库
    
}

@end
