//
//  PAS_3DTouch.h
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAS_3DTouch : NSObject
//添加3DTouch项
+ (void)PAS_Add3DTouchItems;
//处理3DTouch方法
+ (void)PAS_Handle3DTouchPerformActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem;
@end
