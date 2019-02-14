//
//  MLBaseViewModel.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/8.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLBaseViewModel.h"

@implementation MLBaseViewModel

- (void)setSuccessBlock:(requestSuccessBlock)successBlock
{
    _successBlock = successBlock;
}

- (void)setFailureBlock:(requestFailureBlock)failureBlock
{
    _failureBlock = failureBlock;
}

- (void)requestSuccess:(requestSuccessBlock)successBlock
               failure:(requestFailureBlock)failureBlock
{
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
}

@end
