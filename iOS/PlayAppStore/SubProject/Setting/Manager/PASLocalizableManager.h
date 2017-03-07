//
//  PASLocalizableManager.h
//  PlayAppStore
//
//  Created by Winn on 2017/3/2.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>


#define PASLanguageKey @"userLanguage"
#define PASCHINESE @"zh-Hans"
#define PASCHINESE_IOS9 @"zh-Hans-CN"
#define PASENGLISH @"en"
#define PASNotificationLanguageChanged @"rdLanguageChanged"



@interface PASLocalizableManager : NSObject


+ (instancetype)shareInstance;
/**
 *  获取当前资源文件
 */
- (NSBundle *)bundle;
/**
 *  获取应用当前语言
 */
- (NSString *)userLanguage;

- (NSArray *)english;
// 中文类型数组
- (NSArray *)chinese;
/**
 *  设置当前语言
 */
- (void)setUserlanguage:(NSString *)language;

- (NSString *)stringWithKey:(NSString *)key;

@end
