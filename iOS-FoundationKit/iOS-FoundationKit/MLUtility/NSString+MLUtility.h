//
//  NSString+MLUtility.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MLUtility)

/**
 * 字符串数字校验
 * @returned    bool值
 */
- (BOOL)isNumber;

/**
 * 字符串邮箱校验
 * @returned    bool值
 */
- (BOOL)isValidEmail;

/**
 * 字符串身份证校验(15位、18位)
 * @returned    bool值
 */
- (BOOL)isValidIdentity;

/**
 *  @brief 是否是有效的银行卡号
 *
 *  @return bool值
 */
- (BOOL) isValidBankCardNumber;

/**
 *  @brief 获取字符串的size
 *  @param font  字体
 *  @param width 最大宽度
 *  @return 字符串的size
 */
- (CGSize)MLSizeFormat:(UIFont *)font
               maxWith:(CGFloat)width;

/**
 从data获取16进制字符串
 
 @param data 二进制数据
 @return 16进制字符串
 */
+ (NSString *)hexStringFromData:(NSData *)data;

/**
 将普通字符串转换成16进制字符串
 
 @param plainText 字符串
 @return 16进制字符串
 */
+ (NSString *)hexStringFromString:(NSString *)plainText;

/**
 16进制字符串转换成data
 
 @param hexString 16进制字符串
 @return data 二进制数据
 */
+ (NSData *)dataFromHexString:(NSString *)hexString;


@end
