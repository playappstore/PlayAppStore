/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

/*
 #import <humor.h> : Not planning to implement: dateByAskingBoyOut and dateByGettingBabysitter
 ----
 General Thanks: sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki. Emanuele Vulcano, jcromartiej
*/

#import "NSDate+PASUitls.h"

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (PASUitls)

#pragma mark Relative Dates
/**
 获取系统当前时间对应的明天的时间数据
 
 @return NSDate
 */
+ (NSDate *) dateWithDaysFromNow: (NSUInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}
/**
 获取系统当前时间对应的昨天的时间数据
 
 @return NSDate
 */
+ (NSDate *) dateWithDaysBeforeNow: (NSUInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}
/**
 从现在开始追加days天
 
 @param days 追加天数
 
 @return NSDate
 */
+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}
/**
 从现在开始后退days天
 
 @param days 后退天数
 
 @return NSDate
 */
+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}
/**
 从现在开始追加aHours小时
 
 @param dHours 追加小时数
 
 @return NSDate
 */
+ (NSDate *) dateWithHoursFromNow: (NSUInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}
/**
 从现在开始后退dHours小时
 
 @param dHours 后退小时数
 
 @return NSDate
 */
+ (NSDate *) dateWithHoursBeforeNow: (NSUInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}
/**
 从现在开始追加dMinutes分钟
 
 @param dMinutes 追加分钟数
 
 @return NSDate
 */
+ (NSDate *) dateWithMinutesFromNow: (NSUInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}
/**
 从现在开始后退dMinutes分钟
 
 @param dMinutes 后退分钟数
 
 @return NSDate
 */
+ (NSDate *) dateWithMinutesBeforeNow: (NSUInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

#pragma mark Comparing Dates
#warning 更换数据
/**
 判断当前时间和给定时间是否为同一天
 
 @param aDate 给定时间
 
 @return BOOL
 */
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return (([components1 year] == [components2 year]) &&
			([components1 month] == [components2 month]) && 
			([components1 day] == [components2 day]));
}
/**
 判断当前时间是否为[NSDate date]
 
 @return BOOL
 */
- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}
/**
 判断当前的时间是否为明天
 
 @return BOOL
 */
- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}
/**
 判断当前的时间是否为昨天
 
 @return BOOL
 */
- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}
/**
 * @brief 判断当前的时间和给定时间是否在同一周
 *
 * @param aDate 给定时间
 *
 * @return BOOL
 */
// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if ([components1 weekOfYear] != [components2 weekOfYear]) return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}
/**
 * @brief 判断当前的时间是否是系统时间的本周
 *
 * @return BOOL
 */
- (BOOL) isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}
/**
 * @brief 判断当前的时间是否是系统时间的下周
 *
 * @return BOOL
 */
- (BOOL) isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameYearAsDate:newDate];
}
/**
 * @brief 判断当前的时间是否是系统时间的上一周
 *
 * @return BOOL
 */
- (BOOL) isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameYearAsDate:newDate];
}
/**
 * @brief 判断当前的时间和给定时间为同一年
 *
 * @param aDate 给定时间
 *
 * @return BOOL
 */
- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:aDate];
	return ([components1 year] == [components2 year]);
}
/**
 * @brief 判断当前的时间和系统的时间是否为同一年
 *
 * @return BOOL
 */
- (BOOL) isThisYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return ([components1 year] == [components2 year]);
}
/**
 * @brief 判断当前的时间是否是系统时间的下一年
 *
 * @return BOOL
 */
- (BOOL) isNextYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
	
	return ([components1 year] == ([components2 year] + 1));
}
/**
 判断当前的时间是否是系统时间的上一年
 
 @return BOOL
 */
- (BOOL) isLastYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
	
	return ([components1 year] == ([components2 year] - 1));
}
/**
 判断当前的时间是否早于给定时间
 
 @param aDate 给定时间
 
 @return BOOL
 */
- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self earlierDate:aDate] == self);
}
/**
 判断当前的时间是否晚于给定时间
 
 @param aDate 给定时间
 
 @return BOOL
 */
- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self laterDate:aDate] == self);
}


#pragma mark Adjusting Dates
/**
 当前时间追加dDays天
 
 @param dDays 追加天数
 
 @return NSDate
 */
- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}
/**
 当前时间后退aDays天
 
 @param dDays 回退天数
 
 @return NSDate
 */
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
	return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
	return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
	return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
	NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

#pragma mark Decomposing Dates

- (NSInteger) nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitHour fromDate:newDate];
	return [components hour];
}

- (NSInteger) hour
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components hour];
}

- (NSInteger) minute
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components minute];
}

- (NSInteger) seconds
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components second];
}

- (NSInteger) day
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components day];
}

- (NSInteger) month
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components month];
}

- (NSInteger) weekOfYear
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekOfYear];
}

- (NSInteger) weekday
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekday];
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekdayOrdinal];
}
- (NSInteger) year
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components year];
}

- (NSString *) weekString
{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    return [weekdays objectAtIndex:[self weekday]];
}


#pragma mark 
#pragma mark funtion

// return the date by given the interval day by today. interval can be positive, negtive or zero.
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval
{
    return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval)];
}

// return the date by given the interval day by given day. interval can be positive, negtive or zero.
- (NSDate *)relativedDateWithInterval:(NSInteger)interval
{
    NSTimeInterval givenDateSecInterval = [self timeIntervalSinceDate:[NSDate relativedDateWithInterval:0]];
    return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval+givenDateSecInterval)];
}

// Return the formated string by a given date and seperator.
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSTimeZone* timeZone = [NSDate getDefaultTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:str];
    return date;
}










- (NSString *)weekdayString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *weekdayStr = nil;
    [formatter setDateFormat:@"c"];
    NSInteger weekday = [[formatter stringFromDate:self] integerValue];
    if( weekday==1 ){
        weekdayStr = @"星期日";
    }else if( weekday==2 ){
        weekdayStr = @"星期一";
    }else if( weekday==3 ){
        weekdayStr = @"星期二";
    }else if( weekday==4 ){
        weekdayStr = @"星期三";
    }else if( weekday==5 ){
        weekdayStr = @"星期四";
    }else if( weekday==6 ){
        weekdayStr = @"星期五";
    }else if( weekday==7 ){
        weekdayStr = @"星期六";
    }
    return weekdayStr;
}

- (NSString *)dayTimeString
{
    return [NSString stringWithFormat:@"%@",[self stringWithFormat:@"M月d日 HH:mm"]];
}

- (NSString *)stringWithSeperator:(NSString *)seperator
{
    return [self stringWithSeperator:seperator includeYear:YES];
}

- (NSString *)stringWithFormat:(NSString*)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSDate getDefaultTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:format];
    NSString *string = [formatter stringFromDate:self];
    return string;
}

// Return the formated string by a given date and seperator, and specify whether want to include year.
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear
{
    if( seperator==nil ){
        seperator = @"-";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if( includeYear ){
        [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",seperator,seperator]];
    }else{
        [formatter setDateFormat:[NSString stringWithFormat:@"MM%@dd",seperator]];
    }
    NSString *dateStr = [formatter stringFromDate:self];
    
    return dateStr;
}


+ (NSString *)timeStamp
{
    return [NSString stringWithFormat:@"%ld",(long)([[NSDate date] timeIntervalSince1970] * 1000)];
}


+ (NSString *)hoursStringWithTime:(NSNumber *)time
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSTimeZone* timeZone = [self getDefaultTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    NSString *date = [formatter stringFromDate:confromTimesp];
    NSArray *array = [date componentsSeparatedByString:@"-"];
    NSString *str = [NSString stringWithFormat:@"%@月%@日 %@:%@", [array objectAtIndex:1],  [array objectAtIndex:2], [array objectAtIndex:3], [array objectAtIndex:4]];
    return str;
}

+ (NSString *) timeStringWithInterval:(NSTimeInterval)time
{
    
    int distance = [[NSDate date] timeIntervalSince1970] - time;
    NSString *string;
    if (distance < 1){//avoid 0 seconds
        string = @"刚刚";
    }
    else if (distance < 60) {
        string = [NSString stringWithFormat:@"%d秒前", (distance)];
    }
    else if (distance < 3600) {//60 * 60
        distance = distance / 60;
        string = [NSString stringWithFormat:@"%d分钟前", (distance)];
    }
    else if (distance < 86400) {//60 * 60 * 24
        distance = distance / 3600;
        string = [NSString stringWithFormat:@"%d小时前", (distance)];
    }
    else if (distance < 604800) {//60 * 60 * 24 * 7
        distance = distance / 86400;
        string = [NSString stringWithFormat:@"%d天前", (distance)];
    }
    else if (distance < 2419200) {//60 * 60 * 24 * 7 * 4
        distance = distance / 604800;
        string = [NSString stringWithFormat:@"%d周前", (distance)];
    }
    else {
        NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
        
    }
    return string;
}

+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format
{
    NSLog(@"NSDate = %@",date);
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSDate getDefaultTimeZone];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

+ (NSTimeZone *)getDefaultTimeZone
{
    return [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
}

+ (NSString *)stringTodayShow:(NSNumber *)time
{
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time.longLongValue];
    return [NSDate stringTodayDateShow:timeDate];
}

+ (NSString *)stringTodayDateShow:(NSDate *)date
{
    NSDate *todayDate = [NSDate date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    todayDate = [formatter dateFromString:[formatter stringFromDate:todayDate]];

    if ([date timeIntervalSinceDate:todayDate] <  60 * 60 * 24  && [date timeIntervalSinceDate:date] >= 0) {
        [formatter setDateFormat:@"HH:mm"];
    } else {
        [formatter setDateFormat:@"MM-dd"];
    }
    return [formatter stringFromDate:date];
    
}

// 一处使用
+ (NSString *)hoursOrDayTimeStringWithTime:(NSNumber *)time
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    date = [formatter dateFromString:[formatter stringFromDate:date]];
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time.longLongValue];
    if ([timeDate timeIntervalSinceDate:date] <  60 * 60 * 24  && [timeDate timeIntervalSinceDate:date] >= 0) {
        [formatter setDateFormat:@"HH:mm"];
    } else {
        [formatter setDateFormat:@"MM-dd"];
    }
    return [formatter stringFromDate:timeDate];
    
}

///////////////////////////////
/**
 *  将0时区的时间转成0时区的时间戳
 */
+ (NSString *)transformToTimestampWithDate:(NSDate *)date{
    NSTimeInterval inter = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld", (long)inter];
}

/**
 *  将0时区的时间戳转成0时区的时间
 */
+ (NSDate *)transformToDateWithTimestamp:(NSString *)timestamp{
    NSTimeInterval inter = [timestamp doubleValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:inter];
    return date;
}

/**
 *  将0时区的时间戳转成8时区的时间文本格式（“2015-12-13 13：34：45”）
 */
+ (NSString *)transformToStringWithTimestamp:(NSString *)timestamp{
    //1.先将时间戳->NSDate
    NSDate *date = [self transformToDateWithTimestamp:timestamp];
    //2.将date->NSString
    return [[self transformToStringWithDate:date] substringToIndex:16];
}


/**
 *  将0时区的时间戳(10位数)转成8时区的时间文本格式（“2012-12-12 12：12”）,带有只有时分的
 */
+ (NSString *)transformToHourMiniteFormatWithTimestamp:(NSString *)timestamp{
    //1.先将时间戳->NSDate
    NSDate *date = [self transformToDateWithTimestamp:timestamp];
    //2.将date->NSString
    return [[self transformToStringWithDate:date] substringToIndex:13];
}
/**
 *  将8时区的时间文本格式（“2015-12-13 13：34：45”）转成 0时区的时间戳
 */
+ (NSString *)transformToTimestampWithString:(NSString *)string{
    //1.先将NSString->NSDate
    NSDate *date = [self transformToDateWithString:string];
    //2.将date->timestamp
    return [self transformToStringWithDate:date];
}

/**
 *  将8时区的时间文本格式（“2015-12-13 13：34：45”）转成 0时区的NSDate
 */
+ (NSDate *)transformToDateWithString:(NSString *)string{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:string];
    return date;
}

/**
 *  将0时区的NSDate转成 8时区的时间文本格式（“2015-12-13 13：34：45”）
 */
+ (NSString *)transformToStringWithDate:(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [df stringFromDate:date];
    return string;
}
@end
