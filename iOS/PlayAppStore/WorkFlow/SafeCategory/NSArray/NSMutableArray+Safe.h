//
//  NSMutableArray+Safe.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Safe)

/**
 safe替换addObject
 
 @param object 传入对象
 */
- (void)safeAddObject:(id)object;

/**
 翻转数组
 
 @return NSMutableArray
 */
- (NSMutableArray *) reverse;
@property (readonly, getter=reverse) NSMutableArray *reversed;

@end
