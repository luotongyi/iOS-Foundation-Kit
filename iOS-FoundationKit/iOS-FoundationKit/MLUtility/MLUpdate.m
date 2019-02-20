//
//  MLUpdate.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/19.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLUpdate.h"

/**
 *  @brief 版本更新字典Model
 */
@implementation MLUpdateModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _updateMsg = @"";
        _updateUrl = @"";
        _version = @"";
        _bundleVersion = @"";
        _forceUpdate = @"";
    }
    return self;
}

@end

/**
 *  @brief 版本更新逻辑处理
 */
@implementation MLUpdate

+ (void)updateApp
{
    
}

@end
