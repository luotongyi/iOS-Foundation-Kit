//
//  UINavigationController+MLHook.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (MLHook)

/**
 *  @brief hook NavigationController的pop和push方法
 **/
+ (void)hookNavigationController;

@end
