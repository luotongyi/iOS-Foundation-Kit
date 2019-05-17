//
//  MLNavigationController.m
//  BasicFramework
//
//  Created by luoty on 2019/5/15.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLNavigationController.h"
#import <objc/runtime.h>

@implementation MLNavigationBar

+ (void)MLNavBarExchangeInstanceMethod:(Class)mlClass
                           originalSel:(SEL)originalSel
                                newSel:(SEL)newSel
{
    Method originalMethod = class_getInstanceMethod(mlClass, originalSel);
    Method newMethod = class_getInstanceMethod(mlClass, newSel);
    
    BOOL isAdd = class_addMethod(mlClass, originalSel,
                                 method_getImplementation(newMethod),
                                 method_getTypeEncoding(newMethod));
    if (isAdd) {
        class_replaceMethod(mlClass, newSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else{
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    [self setBackgroundImage:[self MLImageWithColor:backgroundColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)MLImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        NSString *className = NSStringFromClass([view class]);
        if ([className isEqualToString:@"_UIBarBackground"]
            ||[className isEqualToString:@"_UINavigationBarBackground"]) {
            CGFloat height= [UIApplication sharedApplication].statusBarFrame.size.height;
            CGRect frame = self.bounds;
            frame.size.height = self.frame.size.height+height;
            frame.origin.y = -height;
            view.frame = frame;
        }
    }
}

@end

@interface MLNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation MLNavigationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _enableGesture = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    
    MLNavigationBar *navbar = [[MLNavigationBar alloc]init];
    navbar.hidden = NO;
    [self setValue:navbar forKeyPath:@"_navigationBar"];
}

- (void)setEnableGesture:(BOOL)enableGesture{
    _enableGesture = enableGesture;
    self.interactivePopGestureRecognizer.enabled = _enableGesture;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}

@end
