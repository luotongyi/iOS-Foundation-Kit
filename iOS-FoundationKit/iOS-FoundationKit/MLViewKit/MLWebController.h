//
//  MLWebController.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/25.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 加载Web的控制器
 **/
@interface MLWebController : UIViewController

/**
 *  @brief 加载的H5的链接
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
 *  @brief 是否在新的界面打开跳转的url，默认NO
 *  一次设置，终身受益，设置为YES时，以后一直会跳转新Page
 *  如果只针对某个界面，庆通过jsName方法处理
 **/
@property (nonatomic, assign)   BOOL    pushNewPage;

/**
 *  JS 调用OC 注册 messageHandler 的方法名
 *  window.webkit.messageHandlers.<name>.postMessage(<messageBody>) for all
 *  eg. @[@"showA",@"showB"];
 */
@property (nonatomic, copy  )   NSArray<NSString *> *jsNamesArray;

/**
 8  JS 调用OC 方法实现
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




@property (nonatomic, strong)   UIView *loadingFailView;

@property (nonatomic, strong)   UIView *loadingView;

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
