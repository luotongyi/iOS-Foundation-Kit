//
//  MLNavBar.h
//  BasicFramework
//
//  Created by luoty on 2019/5/23.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ML_STATUS_HEIGHT    [[UIApplication sharedApplication] statusBarFrame].size.height
#define ML_NAVBAR_HEIGHT    (ML_STATUS_HEIGHT+44)

#define ML_SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width

#define ML_ITEM_WIDTH       40
#define ML_ITEM_MARGIN      10


NS_ASSUME_NONNULL_BEGIN

@class MLNavBarItem;

/**
 自定义导航栏，[MLNavBar new]; 直接使用即可
 */
@interface MLNavBar : UIView

#pragma -mark 导航栏主体部分
/**
 是否隐藏导航栏
 */
@property (nonatomic, assign)   BOOL    navBarHidden;

/**
 导航栏背景色
 */
@property (nonatomic, strong)   UIColor *navBackgroundColor;

/**
 导航栏背景图片
 */
@property (nonatomic, strong)   UIImage *navBackgroundImage;

/**
 导航栏alpha设置
 */
@property (nonatomic, assign)   CGFloat navAlpha;

/**
 是否隐藏导航栏底部线条
 */
@property (nonatomic, assign)   BOOL     navLineHidden;

#pragma -mark 标题部分
/**
 标题
 */
@property (nonatomic,   copy)   NSString *navTitle;

/**
 标题颜色
 */
@property (nonatomic, strong)   UIColor *navTitleColor;

/**
 标题字体
 */
@property (nonatomic, strong)   UIFont *navTitleFont;

/**
 * 展示在 controller 里的 View 最开始的Y值，默认是 ML_NAVBAR_HEIGHT
 * 根据 navLineHidden 是否隐藏可以得到
 */
@property (nonatomic, assign)   CGFloat baseViewY;

#pragma -mark 左右按钮部分,最多支持两个按钮

- (void)addLeftItems:(NSArray<MLNavBarItem *> *)items;

- (void)addRightItems:(NSArray<MLNavBarItem *> *)items;

@end

/**
 自定义导航栏Item，[MLNavBarItem new]; 即可创建对象
 */
@interface MLNavBarItem : UIButton

@property (nonatomic,   copy)   NSString *itemTitle;

@property (nonatomic, strong)   UIColor *itemTitleColor;

@property (nonatomic, strong)   UIImage *itemImage;

@property (nonatomic,   copy)   void(^itemHandler)(void);

@end


NS_ASSUME_NONNULL_END
