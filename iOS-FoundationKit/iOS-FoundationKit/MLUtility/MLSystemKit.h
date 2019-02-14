//
//  MLSystemKit.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  @brief 系统默认功能集合
 *  包括：拍照、定位、推送注册
 *  所有涉及到系统功能的都需要在plist文件里配置对应权限
 **/
@interface MLSystemKit : NSObject

+ (void)registeNotification;



@end
