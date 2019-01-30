//
//  UIApplication+MLHook.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (MLHook)

/**
 *  @brief hook按钮事件，但是不能hook手势和touch
 **/
+ (void)hookApplication;

@end
