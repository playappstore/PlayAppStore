//
//  NSDictionary+Safe.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

/**
 safe替换setValue方法
 
 @param anObject 设置对象
 @param aKey     key值
 */
- (void)safeSetObject:(id)anObject forKey:(NSString *)aKey;

/**
 通过safe方法转换obj
 
 @param obj 传入对象
 
 @return NSDictionary
 */
+ (NSDictionary *)safeDictionaryFromObject:(id)obj;

@end
