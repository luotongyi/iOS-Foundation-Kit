//
//  MLShareResult.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MLShareResultType) {
    MLShareResult_Success = 0,       //分享成功，默认
    MLShareResult_Fail,              //分享失败
    MLShareResult_Cancel             //用户取消
};

@interface MLShareResult : NSObject

/**
 *  @brief 分享结果码
 */
@property (nonatomic, assign)   MLShareResultType resultType;
/**
 *  @brief 返回信息
 */
@property (nonatomic, copy  )   NSString *message;


@end
