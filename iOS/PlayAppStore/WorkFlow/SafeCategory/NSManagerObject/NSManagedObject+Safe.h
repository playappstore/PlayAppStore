//
//  NSManagedObject+Safe.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//


#import <CoreData/CoreData.h>

@interface NSManagedObject (Safe)

/**
 coredata的safe方法
 
 @param anObject 传入对象
 @param aKey     key值
 */
- (void)safeSetObject:(id)anObject forKey:(NSString *)aKey;

@end
