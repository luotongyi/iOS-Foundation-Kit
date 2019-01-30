//
//  UIViewController+MLHook.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MLHook)

/**
 *  @brief hook所有Viewcontroller的默认方法
 *  可以按照自己的需要添加（自己实现）
 **/
+ (void)hookViewController;

@end
