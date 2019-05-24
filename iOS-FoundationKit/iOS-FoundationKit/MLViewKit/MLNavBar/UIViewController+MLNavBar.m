//
//  UIViewController+MLNavBar.m
//  BasicFramework
//
//  Created by luoty on 2019/5/23.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "UIViewController+MLNavBar.h"
#import <objc/runtime.h>

@implementation UIViewController (MLNavBar)

- (void)setEnableGesture:(BOOL)enableGesture{
    objc_setAssociatedObject(self, @selector(enableGesture), @(enableGesture), OBJC_ASSOCIATION_ASSIGN);
    
    [((MLNavigationController *)self.navigationController) setEnableGesture:enableGesture];
}

- (BOOL)enableGesture{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setNavBar:(MLNavBar *)navBar{
    objc_setAssociatedObject(self, @selector(navBar), navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MLNavBar *)navBar{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)reloadNavigationBar
{
    [self removeNavBar];
    
    MLNavBar *nav = [MLNavBar new];
    self.navBar = nav;
    [self.view addSubview:nav];
    
}

-(void)removeNavBar
{
    if (self.navBar) {
        [self.navBar removeFromSuperview];
    }
}

@end
