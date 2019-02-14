//
//  MLShareHandler.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLShareObject.h"
#import "MLShareResult.h"

typedef NS_ENUM(NSUInteger, MLShareType) {
    
    MLShareType_WX_Session_Text = 0,//微信聊天界面纯文本
    MLShareType_WX_Session,         //微信聊天界面（新闻）
    MLShareType_WX_Timeline_Text,   //微信朋友圈纯文本
    MLShareType_WX_Timeline,        //微信朋友圈界面（新闻）
    MLShareType_QQ_Zone,            //qq空间（新闻）
    MLShareType_QQ_Session,         //qq聊天界面（新闻）
    MLShareType_QQ_Session_Text,    //qq聊天界面纯文本
    MLShareType_Weibo,              //微博（新闻）
    MLShareType_Weibo_Text,         //微博纯文本
    
    MLShareType_message,            //短信
    MLShareType_PasteBoard,         //复制到画板
    MLShareType_Mail,               //邮件分享
};

@protocol MLShareHandlerDelegate <NSObject>

- (void) shareResultCallback:(MLShareResult *)shareResult;

@end

@interface MLShareHandler : NSObject

@property (nonatomic, assign)   id<MLShareHandlerDelegate> shareDelegate;

/**
 *  @brief 分享单例
 *
 *  @return AIShareHandler对象
 */
+ (instancetype)sharedInstance;

/**
 *  @brief 是否安装某个app
 *
 *  @param shareType 分享途径
 *
 *  @return 是否安装该app
 */
+ (BOOL)isInstalledApp:(MLShareType)shareType;

/**
 *  @brief 各大平台的分享,纯文本的只需要title或者message，不需要传imageUrl和webUrl，有图片的时候最好使用异步拉起该方法，防止图片太大卡死（理论上图片不会大，需要后台控制好）
 *
 *  @param obj  需要分享的对象
 *
 *  分享AIShareObject对象
 */
- (void)shareWithType:(MLShareType)shareType shareObject:(MLShareObject *)obj;


@end
