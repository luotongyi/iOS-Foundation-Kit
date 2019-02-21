//
//  MLSecurity.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 加解密相关内容
 */
@interface MLSecurity : NSObject

/**
 *  RSA公钥加密方法
 *
 *  @param str    需要加密的字符串
 *  @param pubKey 公钥字符串
 */
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

/**
 *  3DES加密方法
 *  @param originalStr    需要加密的字符串
 *  @param cryptKey      字符串Key
 *  return 经过base64转换的string
 */
+ (NSString *)threeDESEncryptStr:(NSString *)originalStr
                       cryptKey:(NSString *)cryptKey;

/**
 *  3DES解密方法
 *  @param encryptStr    需要解密的（经过base64转换的string）字符串
 *  @param cryptKey      字符串Key
 *  return 解密后的string
 */
+ (NSString*)threeDESDecryptStr:(NSString *)encryptStr
                      cryptKey:(NSString *)cryptKey;

/**
 将普通字符进行MD5转换
 @param input 字符串
 @return MD5后的字符串
 */
+ (NSString *)MD5:(NSString *)input;


@end
