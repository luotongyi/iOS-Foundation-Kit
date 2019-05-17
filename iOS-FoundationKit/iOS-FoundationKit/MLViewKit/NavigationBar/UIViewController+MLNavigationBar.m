//
//  UIViewController+MLNavigationBar.m
//  BasicFramework
//
//  Created by luoty on 2019/5/16.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "UIViewController+MLNavigationBar.h"
#import <objc/runtime.h>

@interface UIViewController ()

@property (nonatomic,strong) UINavigationItem *mlNavigationItem;

@end

@implementation UIViewController (MLNavigationBar)

+ (void)load{
    [MLNavigationBar MLNavBarExchangeInstanceMethod:[self class] originalSel:@selector(navigationItem) newSel:@selector(ml_NavigationItem)];
    [MLNavigationBar MLNavBarExchangeInstanceMethod:[self class] originalSel:@selector(setTitle:) newSel:@selector(ml_setTitle:)];
}

- (UINavigationItem *)ml_NavigationItem
{
    if (self.mlNavigationItem) {
        return self.mlNavigationItem;
    }
    return  [self mlNavigationItem];
}

-(void)ml_setTitle:(NSString *)title
{
    [self ml_setTitle:title];
    if (self.mlNavigationItem) {
        self.mlNavigationItem.title = title;
    }
}

- (void)reloadNavigationBar{
    [self removeNavigationBar];
    
    CGSize size = [UIApplication sharedApplication].statusBarFrame.size;
    MLNavigationBar *navigationBar = [[MLNavigationBar alloc]init];
    navigationBar.frame =CGRectMake(0, size.height, size.width, 44);
    self.navigationBar = navigationBar;
    [self.view addSubview:navigationBar];
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.mlNavigationItem = [[UINavigationItem alloc]init];
    self.navigationBar.items = @[self.mlNavigationItem];
}

-(void)removeNavigationBar
{
    if (self.navigationBar) {
        [self.navigationBar removeFromSuperview];
    }
    self.mlNavigationItem = nil;
}

#pragma -setters / getters
-(void)setNavigationBar:(MLNavigationBar *)navigationBar
{
    objc_setAssociatedObject(self, @selector(navigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(MLNavigationBar *)navigationBar
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEnableGesture:(BOOL)enableGesture{
    objc_setAssociatedObject(self, @selector(enableGesture), @(enableGesture), OBJC_ASSOCIATION_ASSIGN);
    ((MLNavigationController*)self.navigationController).enableGesture = enableGesture;
}

- (BOOL)enableGesture{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setMlNavigationItem:(UINavigationItem *)mlNavigationItem{
    objc_setAssociatedObject(self, @selector(mlNavigationItem), mlNavigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UINavigationItem *)mlNavigationItem
{
    return  objc_getAssociatedObject(self, _cmd);
}

@end

@implementation UIView (MLNavigationBar)

+ (void)load{
    [MLNavigationBar MLNavBarExchangeInstanceMethod:[self class] originalSel:@selector(didAddSubview:) newSel:@selector(MLDidAddSubview:)];
}

-(void)MLDidAddSubview:(UIView *)subview
{
    UIViewController *vc= (UIViewController*)[self nextResponder];
    if ([vc isKindOfClass:[UIViewController class]]) {
        if(vc.navigationBar){
            [self bringSubviewToFront:vc.navigationBar];
        }
    }
    [self MLDidAddSubview:subview];
}

@end
