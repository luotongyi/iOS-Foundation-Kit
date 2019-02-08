//
//  UIView+MLFrame.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/8.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "UIView+MLFrame.h"

@implementation UIView (MLFrame)

#pragma mark - getters
- (CGFloat)y
{
    return CGRectGetMinY (self.frame);
}

- (CGFloat)x
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)relativeX
{
    
    CGFloat x = self.x + self.width;
    return x;
}

-(CGFloat)relativeY
{
    CGFloat y = self.y + self.height;
    return y;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

#pragma mark - setters
- (void)setOrigin:(CGPoint)origin
{
    CGRect f  = self.frame;
    if (![NSStringFromCGPoint(origin) isEqualToString:NSStringFromCGPoint(f.origin)])
    {
        f.origin = origin;
        self.frame = f;
    }
}

- (void)setSize:(CGSize)size
{
    CGRect f  = self.frame;
    if (![NSStringFromCGSize(size) isEqualToString:NSStringFromCGSize(f.size)])
    {
        f.size = size;
        self.frame = f;
    }
}

- (void)setWidth:(CGFloat)width
{
    CGRect f  = self.frame;
    if (width != f.size.width)
    {
        f.size.width = width;
        self.frame = f;
    }
}

- (void)setHeight:(CGFloat)height
{
    CGRect f  = self.frame;
    if (height != f.size.height)
    {
        f.size.height = height;
        self.frame = f;
    }
}

- (void)setX:(CGFloat)x
{
    CGRect f  = self.frame;
    if (x != f.origin.x) {
        f.origin.x = x;
        self.frame = f;
    }
}

- (void)setY:(CGFloat)y
{
    CGRect f  = self.frame;
    if (y != f.origin.y) {
        f.origin.y = y;
        self.frame = f;
    }
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    if(center.x != centerX) {
        center.x = centerX;
        self.center = center;
    }
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    if(center.y != centerY) {
        center.y = centerY;
        self.center = center;
    }
}


@end
