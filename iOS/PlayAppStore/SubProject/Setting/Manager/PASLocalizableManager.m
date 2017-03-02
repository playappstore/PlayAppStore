//
//  PASLocalizableManager.m
//  PlayAppStore
//
//  Created by Winn on 2017/3/2.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "PASLocalizableManager.h"


@implementation PASLocalizableManager

static NSBundle *bundle = nil;

+ (instancetype)shareInstance {
    static PASLocalizableManager *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[PASLocalizableManager alloc] init];
    });
    return helper;

}

- (instancetype)init {
    
    if (self = [super init]) {
        
        if (!bundle) {
            NSString *languageString = [[NSUserDefaults standardUserDefaults] valueForKey:PASLanguageKey];
            if(languageString.length == 0){
                // 获取系统当前语言版本
                NSArray *languagesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
                languageString = languagesArray.firstObject;
                [[NSUserDefaults standardUserDefaults] setValue:languageString forKey:@"userLanguage"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            // 避免缓存会出现 zh-Hans-CN 及其他语言的的情况
            if ([[self chinese] containsObject:languageString]) {
                languageString = [[self chinese] firstObject]; // 中文
            } else if ([[self english] containsObject:languageString]) {
                languageString = [[self english] firstObject]; // 英文
            } else {
                languageString = [[self english] firstObject]; // defaultEn
            }
            
            // 获取文件路径
            NSString *path = [[NSBundle mainBundle] pathForResource:languageString ofType:@"lproj"];
            // 生成bundle
            bundle = [NSBundle bundleWithPath:path];

        }
        
    }
    return self;
}


// 获取当前资源文件
- (NSBundle *)bundle{
    return bundle;
}

// 英文类型数组
- (NSArray *)english {
    return @[@"en"];
}

// 中文类型数组
- (NSArray *)chinese {
    return @[@"zh-Hans", @"zh-Hant"];
}

// 获取应用当前语言
- (NSString *)userLanguage {
    NSString *languageString = [[NSUserDefaults standardUserDefaults] valueForKey:PASLanguageKey];
    return languageString;
}

// 设置当前语言
- (void)setUserlanguage:(NSString *)language {
    if([[self userLanguage] isEqualToString:language]) return;
    // 改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    // 持久化
    [[NSUserDefaults standardUserDefaults] setValue:language forKey:PASLanguageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PASNotificationLanguageChanged object:nil];
}

- (NSString *)stringWithKey:(NSString *)key {
    
    if (bundle) {
        return [bundle localizedStringForKey:key value:nil table:@"Localizable"];
    }else {
        return NSLocalizedString(key, nil);
    }
}

@end
