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
    //需要更新版本
    if (model.forceUpdate) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:model.updateInfo preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            exit(0);
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击更新按钮,跳转到appstore
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.updateUrl]];
            exit(0);
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [ [MLInfoUtility getCurrentViewController] presentViewController:alert animated:YES completion:nil];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:model.updateInfo preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (self->_cancelUpdateBlock) {
                self->_cancelUpdateBlock();
            }
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击更新按钮,跳转到appstore
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.updateUrl]];
            exit(0);
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [ [MLInfoUtility getCurrentViewController] presentViewController:alert animated:YES completion:nil];
    }
}

@end
