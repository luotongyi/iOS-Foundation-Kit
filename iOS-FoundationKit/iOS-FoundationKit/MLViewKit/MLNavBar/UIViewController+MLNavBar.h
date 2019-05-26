//
//  UIViewController+MLNavBar.h
//  BasicFramework
//
//  Created by luoty on 2019/5/23.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLNavBar.h"
#import "MLNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MLNavBar)

@property (nonatomic, assign)   BOOL enableGesture;

@property (nonatomic, strong)   MLNavBar *navBar;


/**
 加载navBar，最好在添加完所有的view添加
 也可通过HOOK的方式上线自动放到最上面（还未实现）
 */
- (void)reloadNavigationBar;

@end

NS_ASSUME_NONNULL_END
