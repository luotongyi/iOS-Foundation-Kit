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
    
    NSMutableDictionary *crashInfo = [NSMutableDictionary dictionary];
    [crashInfo setObject:name forKey:@"crashName"];
    [crashInfo setObject:reason forKey:@"crashReason"];
    [crashInfo setObject:[stackArray componentsJoinedByString:@"\n"] forKey:@"crashStack"];
    
#warning 数据库插入，还未完善
    
    
}

@end
