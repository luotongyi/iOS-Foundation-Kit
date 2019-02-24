//
//  MLRouter.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/24.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLRouter.h"
#import "MLInfoUtility.h"

@implementation MLRouter

/**
 *  @brief 根据string获取现有的viewController
 *  @param className 类名
 *  @return 类对象，如果不存在则返回nil
 */
+ (UIViewController *)controllerFromClassName:(NSString *)className
{
    Class vcClass = NSClassFromString(className);
    if (vcClass) {
        UIViewController *vc = [[vcClass alloc]init];
        if([vc isKindOfClass:[UIViewController class]]) {
            return vc;
        }
    }
    return nil;
}

+ (void)pushController:(NSString *)vcClassName params:(NSDictionary *)params
{
    UIViewController *control = [self controllerFromClassName:vcClassName];
    if (!params) {
        return;
    }
    
    [[MLInfoUtility getCurrentViewController].navigationController pushViewController:control animated:YES];
    
}


@end
