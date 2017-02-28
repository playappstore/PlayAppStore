//
//  NSString+Safe.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "NSString+Safe.h"

@implementation NSString (Safe)

+ (NSString *)safeStringFromObject:(id)obj
{
    if (obj == nil) {
        return @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj stringValue];
    }
    else if([obj isKindOfClass:[NSNull class]]) {
#if FFCRASH_SERVER_NULL == 1 && DEBUG == 1
        NSAssert(NO, @"属性为null,查一下吧");
        return obj;
#else
        return nil;
#endif
    }else if ([obj isKindOfClass:[NSArray class]] ||
              [obj isKindOfClass:[NSDictionary class]]) {
        return [obj performSelector:@selector(jsonStringEncoded)];
    } else {
        return [obj description];
    }
}

/**
 *  @brief substringFromIndex的safe方法
 *
 *  @param from 截取的开始位置
 *
 */
- (NSString *)safeSubstringFromIndex:(NSUInteger)from {
    
    if ( from <= 0 ) {
        return @"";
    }
    
    if (from < self.length) {
        return [self substringFromIndex:from];
    }
    return @"";
    
}

/**
 *  @brief substringToIndex的safe方法
 *
 *  @param to 截取的终止位置
 *
 */
- (NSString *)safeSubstringToIndex:(NSUInteger)to {
    
    if ( to <= 0 ) {
        return @"";
    }
    
    if (to < self.length) {
        return [self substringToIndex:to];
    }
    else {
        return [self substringToIndex:self.length];
    }
    
}

@end
