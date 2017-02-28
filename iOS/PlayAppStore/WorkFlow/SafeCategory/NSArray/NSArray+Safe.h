//
//  NSArray+Safe.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Safe)

/**
 safe方法替换objectAtIndex 防止取值越界
 
 @param index 下标
 
 @return id
 */
- (id)safeObjectAtIndex:(NSUInteger)index;

/**
 根据判断转换obj为NSArray
 
 @param obj 入参对象
 
 @return NSArray
 */
+ (NSArray *)safeArrayFromObject:(id)obj;

@end
