//
//  MLAnalyse.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ML_RULE_HTTP       @"http"
#define ML_RULE_HTTPS      @"https"

@interface MLAnalyse : NSURLProtocol

/**
 *  @brief 监听所有经过APP的接口
 **/
+ (void)startMonitor;


@end
