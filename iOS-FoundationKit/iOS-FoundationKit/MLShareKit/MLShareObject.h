//
//  MLShareObject.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MLShareObject : NSObject

/**
 *  @brief 分享的标题，纯文本分享和message只要使用一个，优先title
 */
@property (nonatomic, copy  )   NSString *title;
/**
 *  @brief 分享的内容，纯文本分享和title只要使用一个，优先title
 */
@property (nonatomic, copy  )   NSString *message;
/**
 *  @brief 分享后点击的链接地址，纯文本分享不需要
 */
@property (nonatomic, copy  )   NSString *webUrl;
/**
 *  @brief 分享的缩略图，如果是http开头的，则去网络下载，否则取本地的，纯文本分享不需要
 */
@property (nonatomic, copy  )   NSString *imageUrl;
/**
 *  @brief 短信分享需要使用的联系人，其他不需要
 */
@property (nonatomic, copy  )   NSArray  *recipients;

/**
 大图片分享
 */
@property (nonatomic, copy  )   UIImage *bigImage;


@end
