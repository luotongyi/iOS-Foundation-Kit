//
//  MLShareObject.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/14.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLShareObject.h"

@implementation MLShareObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        _title = @"";
        _message = @"";
        _webUrl = @"";
        _imageUrl = @"";
        _recipients = @[];
        _bigImage = nil;
    }
    return self;
}

@end
