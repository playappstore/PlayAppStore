//
//  PAS_3DTouch.m
//  PlayAppStore
//
//  Created by cheyipai.com on 2017/3/1.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PAS_3DTouch.h"
#import "AppDelegate.h"
@implementation PAS_3DTouch
//添加3DTouch项
+ (void)PAS_Add3DTouchItems {
    
    [self addItems];
    
}
+ (void)addItems {
    
    UIApplicationShortcutItem * item1 = [[UIApplicationShortcutItem alloc]initWithType:@"Follow" localizedTitle:NSLocalizedString(@"Follow", nil) localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLove] userInfo:nil];
    
    UIApplicationShortcutItem * item2 = [[UIApplicationShortcutItem alloc]initWithType:@"Setting" localizedTitle:NSLocalizedString(@"Setting", nil) localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLocation] userInfo:nil];
    
    [UIApplication sharedApplication].shortcutItems = @[item1,item2];
   
}
+ (void)PAS_Handle3DTouchPerformActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem {
    
    if ([shortcutItem.type isEqualToString:@"Follow"]) {
  
        UITabBarController *tableBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tableBar.selectedIndex = 1;
    }else if ([shortcutItem.type isEqualToString:@"Setting"]) {
    
        UITabBarController *tableBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tableBar.selectedIndex = 2;
    }
}
@end
