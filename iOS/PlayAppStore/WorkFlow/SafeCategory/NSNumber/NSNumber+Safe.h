//
//  NSNumber+Safe.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Safe)

/**
 对象的safe判断 如果为NSNumber直接返回 double值时进行转换 NSNull时断言
 
 @param obj 传入对象
 
 @return NSNumber
 */
+ (NSNumber *)safeNumberFromObject:(id)obj;

/**
 对象的safe判断 如果为NSNumber直接返回 double值时进行转换
 
 @param obj 传入对象
 
 @return NSNumber
 */
+ (NSNumber *)safeDoubleNumberFromObject:(id)obj;

@end
