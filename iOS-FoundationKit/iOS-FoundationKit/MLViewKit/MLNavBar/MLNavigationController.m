//
//  MLNavigationController.m
//  BasicFramework
//
//  Created by luoty on 2019/5/15.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLNavigationController.h"

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

//当app集成了侧滑返回手势，在根目录侧滑手势，再任意点击push新的控制器，
//新控制器是push出来的，但页面上却没有，而且界面无法再次点击
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( gestureRecognizer == self.interactivePopGestureRecognizer )
    {
        //  禁用某些不支持侧滑返回的页面
        //        UIViewController *vc = self.viewControllers.lastObject;
        //        if ([vc isKindOfClass:[HomeController class]]) {
        //            return NO;
        //        }
        //  禁用根目录的侧滑手势
        if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] )
        {
            return NO;
        }
    }
    return YES;
}

//当前页面最底层是scrollView时，侧滑手势失效问题处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        if (gestureRecognizer.state != UIGestureRecognizerStatePossible) {
            return YES;
        }
    }
    return NO;
}

@end
