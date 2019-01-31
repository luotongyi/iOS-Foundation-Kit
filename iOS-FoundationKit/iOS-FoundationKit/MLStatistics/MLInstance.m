//
//  MLInstance.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLInstance.h"

@implementation MLInstance

+ (instancetype)sharedInstance
{
    static MLInstance *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _enableLog = NO;
        _registerKey = @"";
    }
    return self;
}


@end
