//
//  NSUserDefaults+Safe.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "NSUserDefaults+Safe.h"

@implementation NSUserDefaults (Safe)

- (void)safeSetObject:(id)anObject forKey:(NSString *)aKey
{
    if ( aKey == nil)
    {
        return;
    }
    else if (anObject == nil )
    {
        [self removeObjectForKey:aKey];
    }
    else
    {
        [self setObject:anObject forKey:aKey];
    }
}

@end
