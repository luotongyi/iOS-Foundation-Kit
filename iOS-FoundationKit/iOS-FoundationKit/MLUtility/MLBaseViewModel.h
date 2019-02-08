//
//  MLBaseViewModel.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/8.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^requestSuccessBlock)(id successValue);

typedef void (^requestFailureBlock)(id failureValue);

/**
 *  @brief MLBaseViewModel的代理
 */
@protocol AIBaseViewModelDelegate <NSObject>

@optional

/**
 *  @brief 发起网络请求
 *  targetSuper 默认方法传控制器的类本身（self），用于控制等待框展示的界面
 *  targetSuper 可以传nil，则不展示
 */
- (void)sendRequest:(NSObject *)targetSuper;

@end

@interface MLBaseViewModel : NSObject

@property (nonatomic, copy  )   requestSuccessBlock successBlock;

@property (nonatomic, copy  )   requestFailureBlock failureBlock;

- (void)requestSuccess:(requestSuccessBlock)successBlock
               failure:(requestFailureBlock)failureBlock;


@end
