//
//  NSManagedObject+Safe.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "NSManagedObject+Safe.h"

@implementation NSManagedObject (Safe)

- (void)safeSetObject:(id)anObject forKey:(NSString *)aKey
{
    if (anObject == nil || aKey == nil)
    {
        return;
    }
    
    [self setValue:anObject forKey:aKey];
}

@end
