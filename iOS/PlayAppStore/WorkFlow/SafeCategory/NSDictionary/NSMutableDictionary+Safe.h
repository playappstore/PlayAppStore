//
//  NSMutableDictionary+Safe.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Safe)

/**
 替换setObject:forKey | safeSetObject:ForKey:
 
 @param anObject 设置对象
 @param aKey     key值
 */
- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

/**
 设置默认object
 
 @param anObject      设置对象
 @param defaultObject 默认对象
 @param aKey          key值
 */
- (void)setObject:(id)anObject defaultObject:(id)defaultObject forKey:(id <NSCopying>)aKey;

/**
 设置默认value
 
 @param value        设置value
 @param defaultValue 默认value
 @param key          key值
 */
- (void)safeSetObject:(id)value defaultValue:(id)defaultValue forKey:(NSString *)key;

@end
