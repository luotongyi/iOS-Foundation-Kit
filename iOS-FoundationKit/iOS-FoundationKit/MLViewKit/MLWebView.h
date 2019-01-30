//
//  MLWebView.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface MLWebView : UIView

/**
 *  @brief web的title，时时更新
 **/
@property (nonatomic, copy  )   NSString *title;

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
 *  @brief message.name，message.body
 **/
@property (nonatomic, copy  )   void(^jsActionBlock)(NSString *name,id body);

/**
 *  @brief jsArray：ScriptMessageHandler方法名
 **/
- (instancetype)initWithConfig:(NSArray *)jsArray frame:(CGRect)frame;

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
- (void)popViewController;

/**
 *  @brief 返回web的history---[wkWebView goBack];
 **/
- (void)goWebHistory;

/**
 *  @brief 返回主界面---popToRootViewController
 **/
- (void)popRootViewController;

@end
