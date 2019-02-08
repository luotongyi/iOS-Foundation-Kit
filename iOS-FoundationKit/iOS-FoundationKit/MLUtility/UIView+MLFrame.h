//
//  UIView+MLFrame.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/8.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 获取view的frame位置，包括坐标x、y、centerX、centerY
 *  width、height、height+y、width+x
 *  origin、size
 */
@interface UIView (MLFrame)

@property (nonatomic,   assign)   CGFloat x;

@property (nonatomic,   assign)   CGFloat y;

@property (nonatomic,   assign)   CGFloat width;

@property (nonatomic,   assign)   CGFloat height;

@property (nonatomic,   assign)   CGFloat centerX;

@property (nonatomic,   assign)   CGFloat centerY;

@property (nonatomic, readonly)   CGFloat relativeX;

@property (nonatomic, readonly)   CGFloat relativeY;

@property (nonatomic,   assign)   CGPoint origin;

@property (nonatomic,   assign)   CGSize  size;


@end
