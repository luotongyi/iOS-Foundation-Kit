//
//  MLUpdate.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/19.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 版本更新字典Model
 */
@interface MLUpdateModel : NSObject

/**
 *  @brief 是否强制更新，默认@""
 */
@property (nonatomic, copy  )   NSString *forceUpdate;

/**
 *  @brief 版本更新后的下载地址，默认@""
 */
@property (nonatomic, copy  )   NSString *updateUrl;

/**
 *  @brief 版本更新的内容，默认@""
 */
@property (nonatomic, copy  )   NSString *updateInfo;

/**
 *  @brief App Store显示的版本号，默认@""
 *  eg.     1.0.0
 */
@property (nonatomic, copy  )   NSString *bundleVersion;

/**
 *  @brief 其他版本号（内部），默认@""
 *  eg. 数字，1、2、3 ...
 */
@property (nonatomic, copy  )   NSString *version;

/**
 *  @brief 是否是灰度环境，默认NO
 */
@property (nonatomic, assign)   BOOL     isGrayVersion;


@end

/**
 *  @brief 版本更新逻辑处理
 */
@interface MLUpdate : NSObject

@property (nonatomic, copy  )   void(^cancelUpdateBlock)(void);

/**
 *  @brief 执行版本更新逻辑
 */
- (void)appUpdateCheck;

@end
