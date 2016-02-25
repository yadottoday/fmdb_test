//
//  DataBaseManage.m
//  fmdb_test
//
//  Created by 王庆华 on 16/2/22.
//  Copyright © 2016年 王庆华. All rights reserved.
//

#import "DataBaseManage.h"
#import "FMDB.h"

@interface DataBaseManage()

{
    /**
     数据库对象
     
     - returns: <#return value description#>
     */
    FMDatabase *_database;
}

@end


@implementation DataBaseManage

+ (NSString *) test{
    

    
    NSInteger type = [DataBaseManage dataBaseManager].type;
    
    switch (type) {
        case 0:
            return nil;
            break;
            
        default:
            return nil;
            break;
    }
    
}

- (instancetype)init {


    self = [super init];
    
    if (self) {
        
        // 1. 创建数据库
        if (![self createDatabaseAndOpen]) {
            // 创建数据库失败
            return nil;
        }
        
        // 创建表
        [self creatUserTable];
    }
    return self;
}


+ (instancetype)dataBaseManager {
    
    static DataBaseManage *manager = nil;
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        manager = [[self alloc] init];
//    });
//    
//    return manager;
//    
    
    @synchronized(self) {
        if (!manager) {
            manager = [[self alloc] init];
        }
    }
    return manager;
}

/**
 *  返回数据库路径
 */

- (NSString *)databasePath {
    
    NSString *doucmentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    return [doucmentPath stringByAppendingPathComponent:@"user.db"];
}

/**
 *  创建数据并打开
 */
- (BOOL)createDatabaseAndOpen {
    
    // 初始化数据库
    _database = [FMDatabase databaseWithPath:[self databasePath]];
    
    // 打开数据: 如果数据库存在 直接打开。 否则先创建数据库然后再打开
    
    if (![_database open]) {
        NSLog(@"打开失败");
        return NO;
    } else {
        NSLog(@"打开成功");
    }

    return YES;
    
}

/**
 *  创建表
 */
- (void)creatUserTable {
    
    NSString *sql = @"create table if not exists User( id integer primary key autoincrement,name text, age integer);";
    
    // 除了查询是executeQusery:操作,其他都是executeUpdate操作
    BOOL isOK = [_database executeUpdate:sql];
    
    if (isOK) {
        NSLog(@"创建表成功");
        NSLog(@"%@",NSHomeDirectory());
    } else {
        NSLog(@"创建表失败");
    }
    
}


- (BOOL)insertIntoTableWithObject:(id)object {
    
    NSString *sql = nil;
    
    // User
    if ([object isKindOfClass:[User class]]) {
        User *user = object;
        
        sql = @"insert into User(name,age) values(?,?)";
        /**
         *  插入数据的时候不能有基本数据类型 
         (int, float, double, bool) 必须是基本类型的包装类
         */
        
        // 执行更新
        return [_database executeUpdate:sql,user.name,@(user.age)];
        
    }
    return NO;
}

/**
 *  查询所有数据
 */

- (NSArray *)queryAllUserObjectsFromDatabase {
    
    NSString *sql = @"select *from User";
    
    // 保存所有用户信息
    NSMutableArray *users = [NSMutableArray array];
    
    // 执行查询，返回结果集
    
    FMResultSet *results = [_database executeQuery:sql];
    
  
    
    // 依次取出
    while (results.next) {
        
        // 根据字段名字取值
        NSString *name = [results stringForColumn:@"name"];
        // 根据索引取值
        [results stringForColumnIndex:1];
        
        int age = [results intForColumn:@"age"];
        
        // 封装数据模型
        User *user = [[User alloc] init];
        user.name = name;
        user.age = age;
        
        // 添加到数组中
        [users addObject:user];
    }
    return users;
}

- (NSArray *)queryObjectsFromDatabaseWithParameters:(NSDictionary *)parameters {
    
    // select * from User where xx = xx and xx = xx
    
    /**
     *  字典遍历
     for (NSString *key in 字典)
     */
    NSMutableString *string = [NSMutableString string];
    
    // 获取字典所有的key
    NSArray *allkeys = parameters.allKeys;
    for (int i = 0; i < parameters.count; i++) {
        
        // key
        NSString *key = allkeys[i];
        if (i == parameters.count - 1) {
            [string appendFormat:@"%@==%@",key,parameters[key]];
        } else {
            [string appendFormat:@"%@=%@ and",key,parameters[key]];
        }
        
    }
    return nil;
    
}

/**
 *  更新数据
 */
- (BOOL)updateUserObjectWithParameters:(NSDictionary *)parameters {
    
    // update User set name = "xxx" where id = "xxx"
    
    
    return NO;
}

/**
 *  把名字删除
 */
- (void)delectUserObjectFromDatabaseWithName:(NSString *)name {
    
    NSString *sql = @"delete from User where name = ?";
    
    [_database executeUpdate:sql,name];
}

/**
 *  数据库关闭
 */
- (BOOL)close {
    
    return [_database close];
}




@end
