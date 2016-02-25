//
//  DataBaseManage.h
//  fmdb_test
//
//  Created by 王庆华 on 16/2/22.
//  Copyright © 2016年 王庆华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface DataBaseManage : NSObject

@property (nonatomic, copy) NSString *nameStr;

@property (nonatomic, assign) NSInteger type;

/**
 *  单例对象
 */

+ (instancetype) dataBaseManager;

/**
 *  插入数据
 */

- (BOOL)insertIntoTableWithObject:(id)object;

+ (NSString *)test;

/**
 *  查询所有数据
 */

- (NSArray *)queryAllUserObjectsFromDatabase;


/**
 *  有条件查询
 */
- (NSArray *)queryObjectsFromDatabaseWithParameters:(NSDictionary *)parameters;

/**
 *  更新数据
 */
- (BOOL)updateUserObjectWithParameters:(NSDictionary *)parameters;

/**
 *  根据名字删除数据
 */
- (void)delectUserObjectFromDatabaseWithName:(NSString *)name;

/**
 *  数据库关闭
 */
- (BOOL)close;

@end
