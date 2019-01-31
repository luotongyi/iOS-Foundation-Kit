//
//  MLSqliteUtility.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSqliteModel.h"

@interface MLSqliteUtility : NSObject

/**
 *  @brief MLSqliteUtility单例
 *  @return MLSqliteUtility对象
 */
+ (instancetype)sharedInstance;

/**
 *  @brief 创建数据库的表
 *  sql 创建表的sql语句
 */
- (void)createTable:(NSString *)sql;


@end
