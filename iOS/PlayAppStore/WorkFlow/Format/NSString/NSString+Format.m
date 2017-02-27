//
//  NSString+Format.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "NSString+Format.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+PASAdd.h"
#import <UIKit/UIKit.h>

@implementation NSString (Format)

#pragma mark -
#pragma mark Long conversions
/*
 * Returns the long value of the string
 */
- (long)longValue {
    return (long)[self longLongValue];
}

- (long long)longLongValue {
    NSScanner* scanner = [NSScanner scannerWithString:self];
    long long valueToGet;
    if([scanner scanLongLong:&valueToGet] == YES) {
        return valueToGet;
    } else {
        return 0;
    }
}
#pragma mark -
#pragma mark Hashes

/*
 * Contact info@enormego.com if you're the author and we'll update this comment to reflect credit
 */
/*
 * Returns the MD5 value of the string
 */
- (NSString *)md5 {
    const char* string = [self UTF8String];
    unsigned char result[16];
    
    CC_LONG lenth = (CC_LONG)strlen(string);
    CC_MD5(string, lenth, result);
    NSString * hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                       result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                       result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    
    return [hash lowercaseString];
}
/*
 * Returns the SHA-1 value of the string
 */
- (NSString *)sha1
{
    
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    
    
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        
        [outputStr appendFormat:@"%02x", digest[i]];
        
    }
    
    return outputStr;
    
}

#pragma mark -
#pragma mark Truncation

/*
 * Contact info@enormego.com if you're the author and we'll update this comment to reflect credit
 */

// 截取最前面的空格 例如 @"  12 34" 截取后@"12 34"
- (NSString *)trimWhiteSpace {
    NSMutableString *s = [self mutableCopy];
    CFStringTrimWhitespace ((CFMutableStringRef) s);
    return (NSString *) [s copy];
} /*trimWhiteSpace*/

+ (NSString *)stringWithFormat:(NSString *)format withArray:(NSArray *) valueArray
{
    if (!format || !valueArray) {
        return nil;
    }
    
    NSString * result = format;
    
    for(id value in valueArray)
    {
        NSRange range = [result rangeOfString:@"%@"];
        if (range.location != NSNotFound) {
            NSString *subStr1 = [result substringToIndex:range.location + 2];
            NSString *subStr2 = [result substringFromIndex:range.location + 2];
            subStr1 = [NSString stringWithFormat:subStr1,value];
            result = [subStr1 stringByAppendingString:subStr2];
        }
    }
    
    return result;
}
/**
 URl解码
 
 @return NSString
 */

- (NSString *)urldecode {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
/**
 URL编码
 
 @return NSString
 */
- (NSString *)urlencode {
    NSString *encUrl = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSInteger len = [encUrl length];
    const char *c;
    c = [encUrl UTF8String];
    NSString *ret = @"";
    for(int i = 0; i < len; i++) {
        switch (*c) {
            case '/':
                ret = [ret stringByAppendingString:@"%2F"];
                break;
            case '\'':
                ret = [ret stringByAppendingString:@"%27"];
                break;
            case ';':
                ret = [ret stringByAppendingString:@"%3B"];
                break;
            case '?':
                ret = [ret stringByAppendingString:@"%3F"];
                break;
            case ':':
                ret = [ret stringByAppendingString:@"%3A"];
                break;
            case '@':
                ret = [ret stringByAppendingString:@"%40"];
                break;
            case '&':
                ret = [ret stringByAppendingString:@"%26"];
                break;
            case '=':
                ret = [ret stringByAppendingString:@"%3D"];
                break;
            case '+':
                ret = [ret stringByAppendingString:@"%2B"];
                break;
            case '$':
                ret = [ret stringByAppendingString:@"%24"];
                break;
            case ',':
                ret = [ret stringByAppendingString:@"%2C"];
                break;
            case '[':
                ret = [ret stringByAppendingString:@"%5B"];
                break;
            case ']':
                ret = [ret stringByAppendingString:@"%5D"];
                break;
            case '#':
                ret = [ret stringByAppendingString:@"%23"];
                break;
            case '!':
                ret = [ret stringByAppendingString:@"%21"];
                break;
            case '(':
                ret = [ret stringByAppendingString:@"%28"];
                break;
            case ')':
                ret = [ret stringByAppendingString:@"%29"];
                break;
            case '*':
                ret = [ret stringByAppendingString:@"%2A"];
                break;
            default:
                ret = [ret stringByAppendingFormat:@"%c", *c];
        }
        c++;
    }
    return ret;
}

- (id)jsonValueDecoded {
    return [[self dataValue] jsonValueDecoded];
}

- (NSData *)dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark
#pragma mark new add

//去掉数字字符串小数点后面无用的0
- (NSString *)stringWithCustomPriceFormat
{
    
    if (!self || self.length <= 0) {
        return @"";
    }
    
    NSMutableString *mutableStr = [NSMutableString stringWithString:self];
    if ([[mutableStr substringFromIndex:mutableStr.length-1] isEqualToString:@"0"] && [mutableStr rangeOfString:@"."].location != NSNotFound) {
        [mutableStr deleteCharactersInRange:NSMakeRange(mutableStr.length-1, 1)];
        return [mutableStr stringWithCustomPriceFormat];
    }
    
    if ([[mutableStr substringFromIndex:mutableStr.length-1] isEqualToString:@"."]) {
        [mutableStr deleteCharactersInRange:NSMakeRange(mutableStr.length-1, 1)];
    }
    
    return mutableStr;
}

- (PasswordStrength)isStrengthPwd
{
    if (!self || self.length <= 0) {
        return weakPassword;
    }
    
    NSString *combineTwoStrong1 = @"(?=^.{13,}$)(?=.*[0-9])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineTwoStrong2 = @"(?=^.{13,}$)(?=.*[0-9])(?=.*[A-Z]).*$";
    NSString *combineTwoStrong3 = @"(?=^.{13,}$)(?=.*[0-9])(?=.*[a-z]).*$";
    NSString *combineTwoStrong4 = @"(?=^.{13,}$)(?=.*[a-z])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineTwoStrong5 = @"(?=^.{13,}$)(?=.*[A-Z])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineTwoStrong6 = @"(?=^.{13,}$)(?=.*[A-Z])(?=.*[a-z]).*$";
    NSString *combineTwoNormal1 = @"(?=^.{8,12}$)(?=.*[0-9])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineTwoNormal2 = @"(?=^.{8,12}$)(?=.*[0-9])(?=.*[A-Z]).*$";
    NSString *combineTwoNormal3 = @"(?=^.{8,12}$)(?=.*[0-9])(?=.*[a-z]).*$";
    NSString *combineTwoNormal4 = @"(?=^.{8,12}$)(?=.*[a-z])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineTwoNormal5 = @"(?=^.{8,12}$)(?=.*[A-Z])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineTwoNormal6 = @"(?=^.{8,12}$)(?=.*[A-Z])(?=.*[a-z]).*$";
    
    NSString *combineThreeStrong1 = @"(?=^.{11,}$)(?=.*[0-9])(?=.*[A-Z])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineThreeStrong2 = @"(?=^.{11,}$)(?=.*[0-9])(?=.*[a-z])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineThreeStrong3 = @"(?=^.{11,}$)(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).*$";
    NSString *combineThreeStrong4 = @"(?=^.{11,}$)(?=.*[a-z])(?=.*[A-Z])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineThreeNormal1 = @"(?=^.{8,10}$)(?=.*[0-9])(?=.*[A-Z])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineThreeNormal2 = @"(?=^.{8,10}$)(?=.*[0-9])(?=.*[a-z])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineThreeNormal3 = @"(?=^.{8,10}$)(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).*$";
    NSString *combineThreeNormal4 = @"(?=^.{8,10}$)(?=.*[a-z])(?=.*[A-Z])(?=.*\\W+)(?!.*\n).*$";
    
    NSString *combineAllStrong = @"(?=^.{10,}$)(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*\\W+)(?!.*\n).*$";
    NSString *combineAllNormal = @"(?=^.{8,9}$)(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*\\W+)(?!.*\n).*$";
    
    NSPredicate *combinePredAllStrong = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineAllStrong];
    NSPredicate *combinePredAllNormal = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineAllNormal];
    
    NSPredicate *combinePredThreeStrong1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineThreeStrong1];
    NSPredicate *combinePredThreeStrong2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineThreeStrong2];
    NSPredicate *combinePredThreeStrong3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineThreeStrong3];
    NSPredicate *combinePredThreeStrong4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineThreeStrong4];
    NSPredicate *combinePredThreeNormal1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineThreeNormal1];
    NSPredicate *combinePredThreeNormal2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineThreeNormal2];
    NSPredicate *combinePredThreeNormal3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineThreeNormal3];
    NSPredicate *combinePredThreeNormal4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineThreeNormal4];
    
    NSPredicate *combinePredTwoStrong1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoStrong1];
    NSPredicate *combinePredTwoStrong2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoStrong2];
    NSPredicate *combinePredTwoStrong3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoStrong3];
    NSPredicate *combinePredTwoStrong4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoStrong4];
    NSPredicate *combinePredTwoStrong5 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoStrong5];
    NSPredicate *combinePredTwoStrong6 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoStrong6];
    NSPredicate *combinePredTwoNormal1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoNormal1];
    NSPredicate *combinePredTwoNormal2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoNormal2];
    NSPredicate *combinePredTwoNormal3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoNormal3];
    NSPredicate *combinePredTwoNormal4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoNormal4];
    NSPredicate *combinePredTwoNormal5 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoNormal5];
    NSPredicate *combinePredTwoNormal6 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",combineTwoNormal6];
    
    if ([combinePredAllStrong evaluateWithObject:self] == YES)
    {
        return strongPassword;
        
    }else if ([combinePredAllNormal evaluateWithObject:self] == YES)
    {
        return normalPassword;
        
    }else if ([combinePredThreeStrong1 evaluateWithObject:self] == YES ||
              [combinePredThreeStrong2 evaluateWithObject:self] == YES ||
              [combinePredThreeStrong3 evaluateWithObject:self] == YES ||
              [combinePredThreeStrong4 evaluateWithObject:self] == YES)
    {
        return strongPassword;
        
    }else if ([combinePredThreeNormal1 evaluateWithObject:self] == YES ||
              [combinePredThreeNormal2 evaluateWithObject:self] == YES ||
              [combinePredThreeNormal3 evaluateWithObject:self] == YES ||
              [combinePredThreeNormal4 evaluateWithObject:self] == YES)
    {
        return normalPassword;
        
    }else if ([combinePredTwoStrong1 evaluateWithObject:self] == YES ||
              [combinePredTwoStrong2 evaluateWithObject:self] == YES ||
              [combinePredTwoStrong3 evaluateWithObject:self] == YES ||
              [combinePredTwoStrong4 evaluateWithObject:self] == YES ||
              [combinePredTwoStrong5 evaluateWithObject:self] == YES ||
              [combinePredTwoStrong6 evaluateWithObject:self] == YES)
    {
        return strongPassword;
        
    }else if ([combinePredTwoNormal1 evaluateWithObject:self] == YES ||
              [combinePredTwoNormal2 evaluateWithObject:self] == YES ||
              [combinePredTwoNormal3 evaluateWithObject:self] == YES ||
              [combinePredTwoNormal4 evaluateWithObject:self] == YES ||
              [combinePredTwoNormal5 evaluateWithObject:self] == YES ||
              [combinePredTwoNormal6 evaluateWithObject:self] == YES)
    {
        return normalPassword;
        
    }else
    {
        return weakPassword;
    }
}

- (NSString *)stringToNumberString
{
    if (!self || self.length <= 0) {
        return @"";
    }
    NSString *string = self;
    for (int i = 0; i<[self length]; i++) {
        BOOL isMatch = [[string substringWithRange:NSMakeRange(i, 1)] isNumber];
        if (!isMatch) {
            string = [string stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"-"];
        }
    }
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return string;
}

+ (NSString *)safeFormatString:(id)obj
{
    if (!obj) {
        return @"";
    } else if ([obj isKindOfClass:[NSString class]]) {
        if ([obj isEqualToString:@"(null)"]) {
            return @"";
        }
        return obj;
    } else {
        return [obj description];
    }
}

#pragma mark - URLScheme From Plist
+ (NSString *)stringURLSchemeWithKeyword:(NSString *)keyworkd
{
    NSArray *ary = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    for (NSDictionary *dic in ary) {
        NSString *urlName = [dic objectForKey:@"CFBundleURLName"];
        if ([urlName isEqualToString:keyworkd]) {
            NSArray *schemes = [dic objectForKey:@"CFBundleURLSchemes"];
            for (NSString *scheme in schemes) {
                if (scheme.length > 0) {
                    return scheme;
                }
            }
        }
    }
    return @"";
}

#pragma mark ---
#pragma mark Validate

- (BOOL)isAValidChinaMobileNumber
{
    
    if (!self || self.length <= 0) {
        return NO;
    }
    
    NSString *regex = @"^1\\d{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValiIDCareNum{
    
    if (!self || self.length <= 0) {
        return NO;
    }
    NSString *cardRegex = @"[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$|^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardRegex];
    return [cardTest evaluateWithObject:self];
}

- (BOOL)isNumber
{
    if (!self || self.length <= 0) {
        return NO;
    }
    
    NSString * regex = @"^[1-9]\\d*|0$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

+ (BOOL)canTel:(NSString *)telStr
{
    telStr = [telStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    telStr = [telStr stringByReplacingOccurrencesOfString:@"转" withString:@","];
    if (!(telStr && telStr.length)) {
        return NO;
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",telStr]]] == YES) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",telStr]]];
        return YES;
    }
    return NO;
}
@end
