//
//  MLWebController.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/25.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 加载WKWebView的控制器
 **/
@interface MLWebController : UIViewController

/**
 *  @brief 加载的H5的链接，也可以是本地html（index.html）
 **/
@property (nonatomic, copy  )   NSString *url;

/**
 *  @brief 自定义的UA，默认为""
 **/
@property (nonatomic, copy  )   NSString *userAgent;

/**
 *  @brief url的requestHeader里的内容，string形式的key和value，默认@{}
 **/
@property (nonatomic, copy  )   NSDictionary *headerParams;

/**
 *  JS 调用OC 注册 messageHandler 的方法名
 *  window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
 *  eg. @[@"showA",@"showB"];
 *
 *  window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
 *  已存在的默认方法：
 */
@property (nonatomic, copy  )   NSArray<NSString *> *jsNamesArray;

/**
 8  JS 调用OC 方法实现，需要开发者自己实现
 *  @brief message.name，message.body
 *  eg. [controller setJsCallNativeBlock:^(NSString *name, id body) {
 *
 *      }];
 **/
@property (nonatomic, copy  )   void(^jsCallNativeBlock)(NSString *name,id body);

/**
 *  OC调用JS方法回调
 *  response js回调结果
 */
@property (nonatomic, copy  )   void(^evaluateJSBlock)(id response);

/**
 *  OC调用JS方法
 *  jsMethod js内容
 *  eg. [NSString stringWithFormat:@"writeCardCallback(%@);",[array toJSONString]];
 */
- (void)handleJS:(NSString *)js;

/**
 *  @brief 加载URL
 **/
- (void)loadUrl;

/**
 *  @brief 刷新界面
 */
- (void)refresh;

/**
 *  @brief 返回上一个界面---popViewController
 */
- (void)popController;

/**
 *  @brief 返回web的history---[wkWebView goBack];
 *  如果已经到了history的最后，则调用popController
 **/
- (void)goWebHistory;

/**
 *  @brief 返回主界面---popToRootViewController
 **/
- (void)popRootController;


@end
