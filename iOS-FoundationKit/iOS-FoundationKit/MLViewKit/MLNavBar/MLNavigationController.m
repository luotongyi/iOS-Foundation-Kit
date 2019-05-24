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

@end
