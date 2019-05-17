//
//  UIViewController+MLNavigationBar.h
//  BasicFramework
//
//  Created by luoty on 2019/5/16.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MLNavigationBar)

@property (nonatomic,assign) BOOL enableGesture;

@property (nonatomic,strong) MLNavigationBar *navigationBar;

- (void)reloadNavigationBar;

@end

@interface UIView (MLNavigationBar)

@end

NS_ASSUME_NONNULL_END
