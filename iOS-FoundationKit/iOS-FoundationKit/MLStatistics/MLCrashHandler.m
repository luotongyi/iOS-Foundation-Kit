//
//  MLCrashHandler.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLCrashHandler.h"
#include <execinfo.h>

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

void SignalExceptionHandler(int signal){
    NSArray *callStack = [MLCrashHandler backtraceArray];
    NSString *name = @"LMSignalException";
    NSString *reson = [NSString stringWithFormat:@"signal %d was raised",signal];
    NSLog(@"名字：%@ \n原因：%@\n信号捕获崩溃，堆栈信息：%@ \n",name,reson,callStack);
    
    //TODO:上传Exception信息
}

+ (NSArray *)backtraceArray
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i = 0; i < frames; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

@end
