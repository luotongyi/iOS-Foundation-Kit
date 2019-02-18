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
 */
-(NSString *)threeDESEncryptStr:(NSString *)originalStr
                       cryptKey:(NSString *)cryptKey;

/**
 *  3DES解密方法
 *  @param encryptStr    需要解密的字符串
 *  @param cryptKey      字符串Key
 */
-(NSString*)threeDESDecryptStr:(NSString *)encryptStr
                      cryptKey:(NSString *)cryptKey;

@end
