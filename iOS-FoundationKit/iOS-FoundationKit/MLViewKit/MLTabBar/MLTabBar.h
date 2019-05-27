//
//  MLTabBar.h
//  BasicFramework
//
//  Created by luoty on 2019/5/20.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MLTabBarDelegate <NSObject>

/** 选中tabbar */
- (void)selectedMLTabBarIndex:(NSInteger)index;
@end

@class MLTabBarItem;

@interface MLTabBar : UITabBar

@property (nonatomic, assign) NSInteger            selectedIndex;

@property (nonatomic,   weak) id<MLTabBarDelegate> mlTabBarDelegate;

//不要手动设置此数组，此数组用于设置 MLTabBarItem 相关内容
@property (nonatomic, strong) NSMutableArray<MLTabBarItem *>  *itemArray;

+ (instancetype)tabBarWithFrame:(CGRect)frame
                         titles:(NSArray<NSString *> *)titles
                         images:(NSArray<NSString *> *)images
                 selectedImages:(NSArray<NSString *> *)selectedImages;

@end

@interface MLTabBarItem : UIControl

@property (nonatomic,   copy) NSString *title;

//默认 lightGrayColor
@property (nonatomic, strong) UIColor  *color;

//默认 blueColor
@property (nonatomic, strong) UIColor  *selectedColor;

@property (nonatomic,   copy) NSString *badge;

//默认 whiteColor
@property (nonatomic, strong) UIColor  *badgeColor;

//默认 redColor
@property (nonatomic, strong) UIColor  *badgeBackgroundColor;

@property (nonatomic, strong) UIImage  *image;

@property (nonatomic, strong) UIImage  *selectedImage;

@property (nonatomic, assign) BOOL     itemSelected;

@end

NS_ASSUME_NONNULL_END
