//
//  MLRequestItem.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLRequestItem.h"

@implementation MLRequestItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeInterval = 20;
        _serverUrl = @"";
        _functionPath = @"";
        _requestParams = @{};
        _headerParams = @{};
        _requestMethod = MLHTTP_POST;
    }
    return self;
}

@end
