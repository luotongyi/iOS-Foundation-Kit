//
//  MLUtility.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLUtility : NSObject

/**
 *  @brief 获取APP版本号
 *  return "1.0.1"
 **/
+ (NSString *)getAppVersion;

/**
 *  @brief 获取APP的BundleID
 *  return "com.xxx.xxx"
 **/
+ (NSString *)getPackageName;

/**
 *  @brief 获取设备系统版本号
 *  return "12.0"
 **/
+ (NSString *)getSystemVersion;

/**
 *  @brief 判断设备型号，eg：iPhoneX
 *  return eg."iPhoneX"
 **/
+ (NSString *)getDeviceModel;

/**
 *  @brief 获取设备使用的网络
 *  return eg."WIFI"、"4G"
 **/
+ (NSString *)getNetworkType;

/**
 *  @brief 获取设备UUID，当APP卸载再次安装，UUID会改变
 *  return eg."1271436C-2E99-4845-8088-151E8EFC0094"
 **/
+ (NSString *)getUUID;

/**
 *  @brief 创建文件
 *  fileName: 创建的文件名
 *  retrun: NSDocumentDirectory下的文件路径
 **/
+ (NSString *)createFile:(NSString *)fileName;

@end
