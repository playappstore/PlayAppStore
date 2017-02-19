//
//  NSMutableDictionary+Safe.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"

@implementation NSMutableDictionary (Safe)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject == nil || aKey == nil)
    {
        return;
    }
    [self setObject:anObject forKey:aKey];
}


- (void)setObject:(id)anObject defaultObject:(id)defaultObject forKey:(id <NSCopying>)aKey
{
    if (!aKey) {
        return;
    }
    if (anObject) {
        [self setObject:anObject  forKey:aKey];
    }
    else if(defaultObject)
    {
        [self setObject:defaultObject  forKey:aKey];
    }
    else
    {
        [self setObject:@""  forKey:aKey];
    }
    
}

- (void)safeSetObject:(id)value defaultValue:(id)defaultValue forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    if (value) {
        [self safeSetObject:value  forKey:key];
    }
    else if(defaultValue)
    {
        [self safeSetObject:defaultValue  forKey:key];
    }
    else
    {
        [self safeSetObject:@""  forKey:key];
    }
}

@end
