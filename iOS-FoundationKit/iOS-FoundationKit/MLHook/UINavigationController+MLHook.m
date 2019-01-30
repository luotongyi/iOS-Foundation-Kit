//
//  UINavigationController+MLHook.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "UINavigationController+MLHook.h"
#import <objc/runtime.h>

#import "Macro.h"

@implementation UINavigationController (MLHook)

+ (void)hookNavigationController
{
    Method pushMethod = class_getInstanceMethod([self class], @selector(pushViewController:animated:));
    Method hookPushMethod = class_getInstanceMethod([self class], @selector(hookPushViewController:animated:));
    method_exchangeImplementations(pushMethod, hookPushMethod);
    
    Method popMethod = class_getInstanceMethod([self class], @selector(popViewControllerAnimated:));
    Method hookPopMethod = class_getInstanceMethod([self class], @selector(hookPopViewControllerAnimated:));
    method_exchangeImplementations(popMethod, hookPopMethod);
}

- (void)hookPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSString *popDetailInfo = [NSString stringWithFormat: @"%@ - %@ - %@", NSStringFromClass([self class]), @"pushViewController", NSStringFromClass([viewController class])];
    ML_LOG(@"%@", popDetailInfo);
    [self hookPushViewController:viewController animated:animated];
}

- (void)hookPopViewControllerAnimated:(BOOL)animated
{
    NSString *popDetailInfo = [NSString stringWithFormat:@"%@ - %@", NSStringFromClass([self class]), @"popViewController"];
    ML_LOG(@"%@", popDetailInfo);
    [self hookPopViewControllerAnimated:animated];
}

@end
