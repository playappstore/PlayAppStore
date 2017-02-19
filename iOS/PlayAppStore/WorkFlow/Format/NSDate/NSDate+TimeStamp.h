//
//  NSDate+TimeStamp.h
//  PlayAppStore
//
//  Created by Winn on 2017/2/19.
//  Copyright © 2017年 Winn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeStamp)

/**
 使用获取到的毫秒时间戳根据格式转换成NSString
 
 @param timeStampStr 获取到的毫秒时间戳
 @param format       时间格式
 
 @return NSString
 */
+ (NSString *)dateStringFromTimeStampString:(NSString *)timeStampStr withFormat:(NSString *)format;

/**
 使用获取到的时间戳（非毫秒）根据格式转换成NSString
 
 @param seconds 时间戳（非毫秒）
 @param format  时间格式
 
 @return NSString
 */
+ (NSString *)dateStringFromSeconds:(NSString *)seconds withFormat:(NSString *)format;

@end
