//
//  MLSystemKit.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLSystemKit.h"

@implementation MLSystemKit

+ (void)registeNotification
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge| UIUserNotificationTypeSound|UIUserNotificationTypeAlert  categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    //申请使用通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

@end
