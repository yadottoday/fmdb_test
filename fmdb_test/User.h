//
//  User.h
//  fmdb_test
//
//  Created by 王庆华 on 16/2/22.
//  Copyright © 2016年 王庆华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

// 名字
@property (nonatomic, copy) NSString *name;

// 年龄
@property (nonatomic, assign) int age;

// 地址
@property (nonatomic, copy) NSString *address;
@end
