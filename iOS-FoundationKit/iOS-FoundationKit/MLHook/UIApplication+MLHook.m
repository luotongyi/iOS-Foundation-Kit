//
//  UIApplication+MLHook.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "UIApplication+MLHook.h"
#import <objc/runtime.h>

#import "Macro.h"

@implementation UIApplication (MLHook)

+ (void)hookApplication
{
    Method controlMethod = class_getInstanceMethod([UIApplication class], @selector(sendAction:to:from:forEvent:));
    Method hookMethod = class_getInstanceMethod([self class], @selector(hookSendAction:to:from:forEvent:));
    method_exchangeImplementations(controlMethod, hookMethod);
}

- (BOOL)hookSendAction:(SEL)action to:(nullable id)target from:(nullable id)sender forEvent:(nullable UIEvent *)event;
{
    NSString *actionDetailInfo = [NSString stringWithFormat:@" %@ - %@ - %@", NSStringFromClass([target class]), NSStringFromClass([sender class]), NSStringFromSelector(action)];
    ML_LOG(@"%@", actionDetailInfo);
    return [self hookSendAction:action to:target from:sender forEvent:event];
}

@end
