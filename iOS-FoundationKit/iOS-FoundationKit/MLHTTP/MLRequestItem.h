//
//  MLRequestItem.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MLHTTPMethod) {
    MLHTTP_POST = 0,         //POST请求，默认
    MLHTTP_GET,              //GET请求
};

@interface MLRequestItem : NSObject

/**
 * http请求时间，默认时间20s，如无特殊必要，请不要随意改动
 */
@property (nonatomic, assign)   NSInteger timeInterval;

/**
 * http请求，host地址，默认@""
 * eg，@"http://www.baidu.com"
 */
@property (nonatomic, copy  )   NSString *serverUrl;

/**
 * http请求的路径，默认@""
 * eg, @"/api/fm/login"
 */
@property (nonatomic, copy  )   NSString *functionPath;

/**
 * http请求的参数，默认@{}，没有参数
 */
@property (nonatomic, strong)   NSDictionary *requestParams;

/**
 * http请求的头参数，默认@{}，没有参数
 */
@property (nonatomic, strong)   NSDictionary *headerParams;

/**
 * http请求的方式，默认post请求
 */
@property (nonatomic, assign)   MLHTTPMethod requestMethod;

/**
 *  是否有网络等待框，YES展示，NO不展示，默认为NO
 *  当为YES时，必须设置targetSuper
 */
@property (nonatomic, assign)   BOOL         showDialog;

/**
 *  发出请求方, 默认为 nil
 *  设置当前网络发送者，UIView或者UIViewController
 */
@property (nonatomic, weak  )   NSObject     *targetSuper;


@end
