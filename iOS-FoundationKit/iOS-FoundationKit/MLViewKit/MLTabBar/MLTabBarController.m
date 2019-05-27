//
//  MLTabBarController.m
//  BasicFramework
//
//  Created by luoty on 2019/5/20.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLTabBarController.h"

@implementation MLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)addControllers:(NSArray<UIViewController *> *)controllers
                titles:(NSArray<NSString *> *)titles
                images:(NSArray<NSString *> *)images
        selectedImages:(NSArray<NSString *> *)selectedImages{
    self.mlTabBar = [MLTabBar tabBarWithFrame:self.tabBar.bounds titles:titles images:images selectedImages:selectedImages];
    self.mlTabBar.mlTabBarDelegate = self;
    [self setValue:self.mlTabBar forKeyPath:@"tabBar"];
    
    self.viewControllers = controllers;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    self.mlTabBar.selectedIndex = selectedIndex;
}

#pragma -mark MLTabBarDelegate
- (void)selectedMLTabBarIndex:(NSInteger)index{
    self.selectedIndex = index;
}


@end
