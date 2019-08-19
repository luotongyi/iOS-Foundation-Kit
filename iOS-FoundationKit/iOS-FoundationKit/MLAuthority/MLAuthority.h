//
//  MLAuthority.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/8/19.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

//基于iOS9及以上系统使用
typedef NS_ENUM(NSUInteger, MLAuthorityType) {
    MLCamera = 0,       //相机权限
    MLMedia,            //媒体权限
    MLPhotoLibrary,     //相册权限
    MLContacts,         //通讯录权限
    MLLocation,         //定位权限
    MLBluetooth,        //蓝牙权限
    MLMicrophone,       //麦克风权限
    MLSpeech,           //语音识别权限，iOS10以上才可以使用
    
    MLUserNotification  //通知权限
};

NS_ASSUME_NONNULL_BEGIN

@interface MLAuthority : NSObject


/**
 检查权限是否打开

 @param authType 权限类型
 @param completeBlock 是否开启权限回调
 */
+ (void)checkAuthority:(MLAuthorityType)authType complete:(void (^)(BOOL result))completeBlock;

@end

NS_ASSUME_NONNULL_END
