//
//  UIViewController+MLHook.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "UIViewController+MLHook.h"
#import <objc/runtime.h>

#import "Macro.h"

@implementation UIViewController (MLHook)

+ (void)hookViewController
{
    Method appearMethod = class_getInstanceMethod([self class], @selector(viewDidAppear:));
    Method hookAppearMethod = class_getInstanceMethod([self class], @selector(hookViewDidAppear:));
    method_exchangeImplementations(appearMethod, hookAppearMethod);
    
    Method disappearMethod = class_getInstanceMethod([self class], @selector(viewDidDisappear:));
    Method hookDisappearMethod = class_getInstanceMethod([self class], @selector(hookViewDidDisappear:));
    method_exchangeImplementations(disappearMethod, hookDisappearMethod);
}

- (void)hookViewDidAppear:(BOOL)animated
{
    NSString *appearDetailInfo = [NSString stringWithFormat:@" %@ - %@", NSStringFromClass([self class]), @"ViewDidAppear"];
    ML_LOG(@"%@---%@", self.title, appearDetailInfo);
    [self hookViewDidAppear:animated];
}

- (void)hookViewDidDisappear:(BOOL)animated
{
    NSString *appearDetailInfo = [NSString stringWithFormat:@" %@ - %@", NSStringFromClass([self class]), @"ViewDidDisappear"];
    ML_LOG(@"%@---%@", self.title,appearDetailInfo);
    [self hookViewDidDisappear:animated];
}

@end
