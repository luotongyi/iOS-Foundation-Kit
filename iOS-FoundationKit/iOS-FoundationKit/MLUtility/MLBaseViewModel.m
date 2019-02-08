//
//  MLBaseViewModel.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/8.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLBaseViewModel.h"

@implementation MLBaseViewModel

- (void)requestSuccess:(requestSuccessBlock)successBlock
               failure:(requestFailureBlock)failureBlock
{
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
}

@end
