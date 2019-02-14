//
//  MLTipView.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  弱提示，支持多行
 */
@interface MLTipView : UIView

@property (nonatomic, copy  )   UIImage    *bgImage;   //提示语的背景图片，如果没有则不显示

/**
 *  @brief 弱提示单利
 *
 *  @return AIWaitDialog
 */
+ (instancetype)sharedInstance;

/**
 *  显示弱提示文字，默认显示2s
 *
 *  @param tips 显示的文字
 */
- (void)showTips:(NSString *)tips;


/**
 *  显示弱提示文字，可调整显示多久
 *
 *  @param tips  显示的文字
 *  @param delay 延时显示多久
 */
- (void)showTips:(NSString *)tips hideDelay:(NSTimeInterval)delay;

@end
