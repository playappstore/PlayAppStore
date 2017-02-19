//
//  NSObject+Safe.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Safe)

/**
 主要作用是去除NSNull:当obj为NSNull的时候，返回nil
 
 @param obj 传入对象
 
 @return id
 */
+ (id)safeObjectFromObject:(id)obj;

@end
