//
//  MLUpdate.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/19.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLUpdate.h"
#import <UIKit/UIKit.h>
#import "MLInfoUtility.h"
#import "Macro.h"
#import "MLViewUtility.h"

/**
 *  @brief 版本更新字典Model
 */
@implementation MLUpdateModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _updateInfo = @"";
        _updateUrl = @"";
        _version = @"";
        _bundleVersion = @"";
        _forceUpdate = NO;
        _isGrayVersion = NO;
    }
    return self;
}

@end

/**
 *  @brief 版本更新逻辑处理
 */
@implementation MLUpdate

- (void)appUpdateCheck
{
    MLUpdateModel *model = [MLUpdateModel new];
    
    
    NSString *appVersion = @"1";
    if ([model.version integerValue] <= [appVersion integerValue]) {
        return;
    }
    ML_WEAK_SELF(weakSelf)
    //需要更新版本
    if (model.forceUpdate) {
        [MLViewUtility alertController:@"发现新版本" message:model.updateInfo cancelTitle:@"退出" cancelBlcok:^{
            exit(0);
        } comfirmTitle:@"更新" comfirmBlcok:^{
            //点击更新按钮,跳转到appstore
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.updateUrl]];
            exit(0);
        }];
    }
    else{
        [MLViewUtility alertController:@"发现新版本" message:model.updateInfo cancelTitle:@"取消" cancelBlcok:^{
            if (weakSelf.cancelUpdateBlock) {
                weakSelf.cancelUpdateBlock();
            }
        } comfirmTitle:@"更新" comfirmBlcok:^{
            //点击更新按钮,跳转到appstore
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.updateUrl]];
            exit(0);
        }];
    }
}

@end
