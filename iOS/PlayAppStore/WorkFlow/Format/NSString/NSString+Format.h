//
//  NSString+Format.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

//密码强度
typedef NS_ENUM(NSUInteger, PasswordStrength) {
    weakPassword,                                   //弱
    normalPassword,                                 //中
    strongPassword,                                 //强
};

@interface NSString (Format)

/*
 * Returns the MD5 value of the string
 */
- (NSString *)md5;

/*
 * Returns the SHA-1 value of the string
 */
- (NSString *)sha1;

/*
 * Returns the long value of the string
 */
- (long)longValue;

/**
 去除前置空格 例如 @"  12 34" 截取后@"12 34"
 
 @return NSString
 */
- (NSString *)trimWhiteSpace;

/**
 URL编码
 
 @return NSString
 */
- (NSString *)urlencode;

/**
 URl解码
 
 @return NSString
 */
- (NSString *)urldecode;

/**
 JSON解码
 
 @return <#return value description#>
 */
- (id)jsonValueDecoded;



/**
 去掉数字字符串小数点后面无用的0
 
 @return NSString
 */
- (NSString *)stringWithCustomPriceFormat;

/**
 判断密码强弱
 
 @return PasswordStrength
 */
- (PasswordStrength)isStrengthPwd;

/**
 剔除字符串中的分隔符 "-"
 
 @return NSString
 */
- (NSString *)stringToNumberString;

/**
 安全获取obj的内容 剔除(null)内容
 
 @param obj 内容
 
 @return NSString
 */
+ (NSString *)safeFormatString:(id)obj;

@end
