//
//  NSNumber+Safe.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "NSNumber+Safe.h"

@implementation NSNumber (Safe)

+ (NSNumber *)safeNumberFromObject:(id)obj
{
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    if ([obj respondsToSelector:@selector(doubleValue)]) {
        return [NSNumber numberWithDouble:[obj doubleValue]];
    }
    if([obj isKindOfClass:[NSNull class]]) {
#if FFCRASH_SERVER_NULL == 1 && DEBUG == 1
        NSAssert(NO, @"属性为null,查一下吧");
        return obj;
#else
        return nil;
#endif
    }
    return nil;
}

+ (NSNumber *)safeDoubleNumberFromObject:(id)obj
{
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    if ([obj respondsToSelector:@selector(doubleValue)]) {
        return [NSNumber numberWithDouble:[obj doubleValue]];
    }
    return nil;
}

@end
