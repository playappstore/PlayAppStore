//
//  NSMutableSet+Safe.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet (Safe)

/**
 对象非空是插入
 
 @param object 传入对象
 */
- (void)safeAddObject:(id)object;

@end
