//
//  MLShareResult.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLShareResult.h"

@implementation MLShareResult

- (instancetype)init
{
    self = [super init];
    if (self) {
        _message = @"";
        _resultType = MLShareResult_Fail;
    }
    return self;
}

@end
