//
//  MLSqliteInstance.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLSqliteInstance.h"
#import <sqlite3.h>
#import "MLUtility.h"
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
    NSString *fileName = [MLUtility createFile:ML_SQLITE_DB];
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
    [self closeSqliteDB];
}


@end
