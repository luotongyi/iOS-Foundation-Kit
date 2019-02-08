//
//  MLSqliteModel.h
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/31.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  插入数据库的对象，和数据库的字段保持一致
 */
@interface MLSqliteModel : NSObject

//时间戳，主键
@property (nonatomic, copy,readonly)   NSString *timestamp;

//接口信息
@property (nonatomic, copy  )   NSString *interfaceName;

@property (nonatomic, copy  )   NSString *resultCode;

//Crash信息
@property (nonatomic, copy  )   NSString *crashName;

@property (nonatomic, copy  )   NSString *crashTime;

@property (nonatomic, copy  )   NSString *crashReason;

@property (nonatomic, copy  )   NSString *crashStack;

@end
