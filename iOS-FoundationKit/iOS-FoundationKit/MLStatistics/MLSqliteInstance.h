//
//  MLSqliteInstance.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSqliteModel.h"

#define ML_SQLITE_NAME             @"ML_Sqlite.db"

#define ML_TABLE_LOG               @"ML_TABLE_LOG"

#define ML_TABLE_CRASH             @"ML_TABLE_CRASH"

#define ML_SQL_LOG        [NSString stringWithFormat:@"create table if not exists %@(%@ text primary key,%@ text,%@ text)",ML_TABLE_LOG,@"timestamp",@"interfaceName",@"resultCode"]

#define ML_SQL_CRASH      [NSString stringWithFormat:@"create table if not exists %@(%@ text primary key,%@ text,%@ text,%@ text)",ML_TABLE_CRASH,@"timestamp",@"crashName",@"crashReason",@"crashStack"]


@interface MLSqliteInstance : NSObject

/**
 *  @brief MLSqliteInstance单例
 *  @return MLSqliteInstance对象
 */
+ (instancetype)sharedInstance;

/**
 *  @brief 创建数据库的表
 *  sql 创建表的sql语句
 */
- (void)createTable:(NSString *)sql;

/**
 *  @brief 向数据库的表中插入数据
 *  tableName 表名称
 *  model MLSqliteModel对象
 *  需要根据不同的tableName做相应的处理
 */
- (void)insertTable:(NSString *)tableName
        insertModel:(MLSqliteModel *)model;

/**
 *  @brief 按照表里timestamp字段，删除表里的数据
 *  tableName 表名称
 *  index 每次删除的最大条数
 */
- (void)deleteTable:(NSString *)tableName
              limit:(NSString *)index;

/**
 *  @brief 查询表里所有的数据
 *  tableName 表名称
 *  index 每次查询的最大条数
 *  @return MLSqliteModel对象的数组
 */
- (NSMutableArray *)selectFromTable:(NSString *)tableName
                              limit:(NSString *)index;

@end
