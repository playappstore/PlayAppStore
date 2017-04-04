//
//  PASBasicDefine.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/22.
//  Copyright © 2017年 Winn. All rights reserved.
//

#ifndef PASBasicDefine_h
#define PASBasicDefine_h

#define IS_SCREEN_55_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_47_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_40_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_35_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kDefaultWindowSize [UIScreen mainScreen].bounds.size

#define PASLocalizedString(key, value)  [[PASLocalizableManager shareInstance] stringWithKey:key]

#define kNSUserDefaultMainAddress @"MainIPAddress"
#define kNSUserDefaultMainPort @"MainPort"
#define kNSUserDefaultMainHost @"MainHost"




#endif /* PASBasicDefine_h */
