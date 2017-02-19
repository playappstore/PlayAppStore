//
//  NSObject+Safe.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "NSObject+Safe.h"

@implementation NSObject (Safe)

+ (id)safeObjectFromObject:(id)obj
{
    if ([obj isKindOfClass:[NSNull class]]) {
#if FFCRASH_SERVER_NULL == 1 && DEBUG == 1
        NSAssert(NO, @"属性为null,查一下吧");
        return obj;
#else
        return nil;
#endif
    }
    return obj;
}

-(id) objectForKey:(NSString *)key
{
    NSAssert(NO, @"检查下代码把,不应该调用到这个方法，该方法只用来保护防止崩溃");
    return nil;
}

@end
