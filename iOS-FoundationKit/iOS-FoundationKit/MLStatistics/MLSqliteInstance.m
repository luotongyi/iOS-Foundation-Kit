//
//  MLSqliteInstance.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLSqliteInstance.h"
#import <sqlite3.h>
#import "MLInfoUtility.h"
#import "MLInstance.h"

#define ML_SQLITE_DB    @"ML_SQLITE.db"

@interface MLSqliteInstance()
{
    sqlite3 *database;
}

@end

@implementation MLSqliteInstance

+ (instancetype)sharedInstance{
    static MLSqliteInstance *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc] init];
    });
    return instance;
}

- (void)openSqliteDB
{
    NSString *fileName = [MLInfoUtility createFile:ML_SQLITE_DB];
    int result = sqlite3_open([fileName UTF8String], &database);
    if (result == SQLITE_OK) {
        ML_INFORMATION_LOG(@"创建数据库成功");
    }
}

- (void)closeSqliteDB
{
    int result = sqlite3_close(database);
    if (result == SQLITE_OK) {
        ML_INFORMATION_LOG(@"关闭数据库成功");
    }
}

- (void)createTable:(NSString *)sql
{
    NSString *tableSql = @"";
    if (sql) {
        tableSql = sql;
    }
    [self openSqliteDB];
    int result = sqlite3_exec(database, [tableSql UTF8String], nil, nil, nil);
    if (result == SQLITE_OK) {
        ML_INFORMATION_LOG(@"%@----%@",tableSql,@"创建表成功");
    }
//    [self closeSqliteDB];
}

- (void)insertTable:(NSString *)tableName
        insertModel:(MLSqliteModel *)model
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970]*1000)];
#warning 需要根据不同的tableName做相应的处理
    
    
    ML_INFORMATION_LOG(@"%@--%@",tableName,@"插入数据成功");
}

- (void)deleteTable:(NSString *)tableName
              limit:(NSString *)index
{
    if (!tableName) {
        return;
    }
//    [self openSqliteDB];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where timestamp in (select timestamp from %@ limit 0,%@)",tableName,tableName,index];

    int result = sqlite3_exec(database, [deleteSql UTF8String], nil, nil, nil);
    if (result == SQLITE_OK) {
        ML_INFORMATION_LOG(@"%@--%@---%@",tableName,@"删除数据成功",index);
    }
//    [self closeSqliteDB];
}

- (NSMutableArray *)selectFromTable:(NSString *)tableName
                              limit:(NSString *)index
{
    if (!tableName) {
        return [NSMutableArray array];
    }
//    [self openSqliteDB];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ limit 0,%@",tableName,index];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil);
    NSMutableArray *modelArray = [NSMutableArray array];
    
    
//    [self closeSqliteDB];
    return modelArray;
}

@end
