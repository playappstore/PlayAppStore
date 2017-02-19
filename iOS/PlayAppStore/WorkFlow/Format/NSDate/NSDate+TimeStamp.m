//
//  NSDate+TimeStamp.m
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import "NSDate+TimeStamp.h"
#import "NSDate+PASUitls.h"

@implementation NSDate (TimeStamp)

/**
 使用获取到的毫秒时间戳根据格式转换成NSString
 
 @param timeStampStr 获取到的毫秒时间戳
 @param format       时间格式
 
 @return NSString
 */
+ (NSString *)dateStringFromTimeStampString:(NSString *)timeStampStr withFormat:(NSString *)format {
    NSDate *confirmTimeS = [NSDate dateWithTimeIntervalSince1970:[timeStampStr longLongValue] / 1000];
    NSString *timeStr = [confirmTimeS stringWithFormat:format];
    return timeStr;
}
/**
 使用获取到的时间戳（非毫秒）根据格式转换成NSString
 
 @param seconds 时间戳（非毫秒）
 @param format  时间格式
 
 @return NSString
 */
//不带毫秒
+ (NSString *)dateStringFromSeconds:(NSString *)seconds withFormat:(NSString *)format {
    NSDate *confirmTimeS = [NSDate dateWithTimeIntervalSince1970:[seconds longLongValue]];
    NSString *timeStr = [confirmTimeS stringWithFormat:format];
    return timeStr;
}

@end
