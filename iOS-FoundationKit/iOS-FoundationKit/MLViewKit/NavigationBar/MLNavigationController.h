//
//  MLNavigationController.h
//  BasicFramework
//
//  Created by luoty on 2019/5/15.
//  Copyright © 2019 luoty. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLNavigationBar : UINavigationBar

@property (nonatomic ,strong) UIColor *backgroundColor;

@property (nonatomic ,strong) UIImage *backgroundImage;

+ (void)MLNavBarExchangeInstanceMethod:(Class)mlClass
                           originalSel:(SEL)originalSel
                                newSel:(SEL)newSel;

@end

@interface MLNavigationController : UINavigationController

@property (nonatomic, assign)   BOOL enableGesture;

@end


NS_ASSUME_NONNULL_END
