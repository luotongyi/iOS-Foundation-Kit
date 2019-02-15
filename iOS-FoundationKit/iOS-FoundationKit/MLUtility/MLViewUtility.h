//
//  MLViewUtility.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/15.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MLViewUtility : NSObject

/**
*  设置圆角，支持局部圆角
*  (注意:需要首先设置控件的bounds或者frame，否则会加载不出来，因为它需要根据child的尺寸来设置)
*  @param corner 圆角的位置
*  @param radio  圆角的尺寸
*  @param child  控件
*/
+ (UIView *)setUpCorner:(UIRectCorner )corner
                   size:(CGSize )radio
                   view:(UIView *)child;

/**
 *  @brief 将string转换成二维码图片
 *  qrString    需要转换的string
 *  rectSize    转换后图片的大小，默认正方形
 *  @return     string转换成二维码之后的图片
 **/
+ (UIImage *)stringConvertToImage:(NSString *)qrString
                             size:(CGFloat)rectSize;



@end
