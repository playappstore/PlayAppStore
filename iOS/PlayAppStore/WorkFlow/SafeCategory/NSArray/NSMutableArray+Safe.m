//
//  NSMutableArray+Safe.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "NSMutableArray+Safe.h"

@implementation NSMutableArray (Safe)

- (void)safeAddObject:(id)object
{
    if (object) {
        [self addObject:object];
    }
}

- (NSMutableArray *) reverse
{
    for (int i=0; i<(floor([self count]/2.0)); i++)
        [self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];
    return self;
}

@end
