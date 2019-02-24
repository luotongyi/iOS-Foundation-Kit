//
//  MLInfoUtility.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MLInfoUtility : NSObject

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
 *  @brief 获取文件路径
 *  fileName: 创建的文件名
 *  retrun: NSDocumentDirectory下的文件路径
 **/
+ (NSString *)getFilePath:(NSString *)fileName;

/**
 *  @brief 归档方式存储本地数据
 *  fileName    文件名称
 *  obj         存储对象，包括数组、字典
 *  objKey      存储obj的key
 *  @return     返回文件是否存储成功：YES、NO
 **/
+ (BOOL)writeToFile:(NSString *)fileName
         fileObject:(id)obj
             objKey:(NSString *)objKey;

/**
 *  @brief 获取归档存储在本地的数据
 *  fileName    文件名称
 *  objKey      存储obj的key
 *  @return     返回归档的数据，包括数组、字典，如果没有，则返回 @"";
 **/
+ (id)readFile:(NSString *)fileName objKey:(NSString *)objKey;

/**
 *  @brief 获取系统当前时间
 *  format 时间格式，默认（nil、@""）：YYYY-MM-dd HH:mm:ss
 *  @return     按照格式返回时间
 **/
+ (NSString *)getCurrentTime:(NSString *)format;

/**
 *  @brief 获取当前显示的ViewController
 *  @return   当前的ViewController
 **/
+ (UIViewController *)getCurrentViewController;

/**
 *  @brief 根据当前view获取ViewController
 *  @return   当前的ViewController
 **/
+ (UIViewController *)findViewController:(UIView *)view;

@end
