//
//  MLUtility.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLUtility.h"
#import <UIKit/UIKit.h>
#import "sys/utsname.h"

@implementation MLUtility


+ (NSString *)getAppVersion
{
    NSDictionary *appDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [appDict objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+ (NSString *)getPackageName
{
    NSDictionary *appDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appBundleID = [appDict objectForKey:@"CFBundleIdentifier"];
    return appBundleID;
}

+ (NSString *)getSystemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)getDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    //simulator
    if ([platform isEqualToString:@"i386"])          return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])        return @"Simulator";
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])     return @"iPhone_1G";
    if ([platform isEqualToString:@"iPhone1,2"])     return @"iPhone_3G";
    if ([platform isEqualToString:@"iPhone2,1"])     return @"iPhone_3GS";
    if ([platform isEqualToString:@"iPhone3,1"])     return @"iPhone_4";
    if ([platform isEqualToString:@"iPhone3,2"])     return @"iPhone_4";
    if ([platform isEqualToString:@"iPhone4,1"])     return @"iPhone_4s";
    if ([platform isEqualToString:@"iPhone5,1"])     return @"iPhone_5";
    if ([platform isEqualToString:@"iPhone5,2"])     return @"iPhone_5";
    if ([platform isEqualToString:@"iPhone5,3"])     return @"iPhone_5C";
    if ([platform isEqualToString:@"iPhone5,4"])     return @"iPhone_5C";
    if ([platform isEqualToString:@"iPhone6,1"])     return @"iPhone_5S";
    if ([platform isEqualToString:@"iPhone6,2"])     return @"iPhone_5S";
    if ([platform isEqualToString:@"iPhone7,1"])     return @"iPhone_6P";
    if ([platform isEqualToString:@"iPhone7,2"])     return @"iPhone_6";
    if ([platform isEqualToString:@"iPhone8,1"])     return @"iPhone_6s";
    if ([platform isEqualToString:@"iPhone8,2"])     return @"iPhone_6s_P";
    if ([platform isEqualToString:@"iPhone8,4"])     return @"iPhone_SE";
    if ([platform isEqualToString:@"iPhone9,1"])     return @"iPhone_7";
    if ([platform isEqualToString:@"iPhone9,3"])     return @"iPhone_7";
    if ([platform isEqualToString:@"iPhone9,2"])     return @"iPhone_7P";
    if ([platform isEqualToString:@"iPhone9,4"])     return @"iPhone_7P";
    if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone_8";
    if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone_8";
    if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone_8P";
    if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone_8P";
    if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone_X";
    if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone_X";
    if ([platform isEqualToString:@"iPhone11,8"])    return @"iPhone_XR";
    if ([platform isEqualToString:@"iPhone11,2"])    return @"iPhone_XS";
    if ([platform isEqualToString:@"iPhone11,4"])    return @"iPhone_XS_Max";
    if ([platform isEqualToString:@"iPhone11,6"])    return @"iPhone_XS_Max";
    
    return @"unknow";
}

+ (NSString *)getNetworkType
{
    BOOL isIPhoneX = [[MLUtility getDeviceModel] hasPrefix:@"iPhone_X"];
    UIApplication *app = [UIApplication sharedApplication];
    id statusBar = [app valueForKeyPath:@"statusBar"];
    NSString *network = @"";
    
    if (isIPhoneX) {
        id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
        UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
        NSArray *subviews = [[foregroundView subviews][2] subviews];
        for (id subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                network = @"WIFI";
            }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                network = [subview valueForKeyPath:@"originalText"];
            }
        }
    }else {
        UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
        NSArray *subviews = [foregroundView subviews];
        for (id subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                switch (networkType) {
                    case 0:
                        network = @"NONE";
                        break;
                    case 1:
                        network = @"2G";
                        break;
                    case 2:
                        network = @"3G";
                        break;
                    case 3:
                        network = @"4G";
                        break;
                    case 5:
                        network = @"WIFI";
                        break;
                    default:
                        break;
                }
            }
        }
    }
    if ([network isEqualToString:@""]) {
        network = @"NO DISPLAY";
    }
    return network;
}

+ (NSString *)getUUID
{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

+ (NSString *)createFile:(NSString *)fileName
{
    NSString *name =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [name stringByAppendingPathComponent:fileName];
    return filePath;
}

@end
