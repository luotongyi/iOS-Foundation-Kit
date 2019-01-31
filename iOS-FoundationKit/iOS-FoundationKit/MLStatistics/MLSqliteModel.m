//
//  MLSqliteModel.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLSqliteModel.h"

@implementation MLSqliteModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970]*1000)];
        _timestamp = timeSp;
        
        _interfaceName = @"";
        _resultCode = @"";
        
        _crashName = @"";
        _crashTime = @"";
        _crashStack = @"";
        _crashReason = @"";
    }
    return self;
}

@end
