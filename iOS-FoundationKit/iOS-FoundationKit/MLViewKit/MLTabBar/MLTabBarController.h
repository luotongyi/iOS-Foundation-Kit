//
//  MLTabBarController.h
//  BasicFramework
//
//  Created by luoty on 2019/5/20.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLTabBarController : UITabBarController<MLTabBarDelegate>

@property (nonatomic, strong) MLTabBar *mlTabBar;

- (void)addControllers:(NSArray<UIViewController *> *)controllers
                titles:(NSArray<NSString *> *)titles
                images:(NSArray<NSString *> *)images
        selectedImages:(NSArray<NSString *> *)selectedImages;

@end

NS_ASSUME_NONNULL_END
