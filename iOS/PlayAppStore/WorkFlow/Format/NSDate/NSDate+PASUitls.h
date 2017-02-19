/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (PASUitls)

// Relative dates from the current date

/**
 获取系统当前时间对应的明天的时间数据

 @return NSDate
 */
+ (NSDate *) dateTomorrow;

/**
 获取系统当前时间对应的昨天的时间数据

 @return NSDate
 */
+ (NSDate *) dateYesterday;

/**
 从现在开始追加days天

 @param days 追加天数

 @return NSDate
 */
+ (NSDate *) dateWithDaysFromNow: (NSUInteger) days;

/**
 从现在开始后退days天

 @param days 后退天数

 @return NSDate
 */
+ (NSDate *) dateWithDaysBeforeNow: (NSUInteger) days;

/**
 从现在开始追加aHours小时

 @param dHours 追加小时数

 @return NSDate
 */
+ (NSDate *) dateWithHoursFromNow: (NSUInteger) dHours;

/**
 从现在开始后退dHours小时

 @param dHours 后退小时数

 @return NSDate
 */
+ (NSDate *) dateWithHoursBeforeNow: (NSUInteger) dHours;

/**
 从现在开始追加dMinutes分钟

 @param dMinutes 追加分钟数

 @return NSDate
 */
+ (NSDate *) dateWithMinutesFromNow: (NSUInteger) dMinutes;

/**
 从现在开始后退dMinutes分钟

 @param dMinutes 后退分钟数

 @return NSDate
 */
+ (NSDate *) dateWithMinutesBeforeNow: (NSUInteger) dMinutes;

// Comparing dates

/**
 判断当前时间和给定时间是否为同一天

 @param aDate 给定时间

 @return BOOL
 */
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;

/**
 判断当前时间是否为[NSDate date]
 
 @return BOOL
 */
- (BOOL) isToday;

/**
 判断当前的时间是否为明天

 @return BOOL
 */
- (BOOL) isTomorrow;

/**
 判断当前的时间是否为昨天

 @return BOOL
 */
- (BOOL) isYesterday;

/**
* @brief 判断当前的时间和给定时间是否在同一周
*
* @param aDate 给定时间
*
* @return BOOL
 */
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;

/**
* @brief 判断当前的时间是否是系统时间的本周
*
* @return BOOL
 */
- (BOOL) isThisWeek;

/**
* @brief 判断当前的时间是否是系统时间的下周
*
* @return BOOL
 */
- (BOOL) isNextWeek;

/**
* @brief 判断当前的时间是否是系统时间的上一周
*
* @return BOOL
 */
- (BOOL) isLastWeek;

/**
* @brief 判断当前的时间和给定时间为同一年
*
* @param aDate 给定时间
*
* @return BOOL
 */
- (BOOL) isSameYearAsDate: (NSDate *) aDate;

/**
* @brief 判断当前的时间和系统的时间是否为同一年
*
* @return BOOL
 */
- (BOOL) isThisYear;

/**
* @brief 判断当前的时间是否是系统时间的下一年
*
* @return BOOL
 */
- (BOOL) isNextYear;

/**
 判断当前的时间是否是系统时间的上一年

 @return BOOL
 */
- (BOOL) isLastYear;

/**
 判断当前的时间是否早于给定时间

 @param aDate 给定时间

 @return BOOL
 */
- (BOOL) isEarlierThanDate: (NSDate *) aDate;

/**
 判断当前的时间是否晚于给定时间

 @param aDate 给定时间

 @return BOOL
 */
- (BOOL) isLaterThanDate: (NSDate *) aDate;

// Adjusting dates

/**
 当前时间追加dDays天

 @param dDays 追加天数

 @return NSDate
 */
- (NSDate *) dateByAddingDays: (NSInteger) dDays;

/**
 当前时间后退aDays天

 @param dDays 回退天数

 @return NSDate
 */
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;

/**
 当前的时间追加dHours小时

 @param dHours 追加小时

 @return NSDate
 */
- (NSDate *) dateByAddingHours: (NSInteger) dHours;

/**
 当前的时间后退dHours小时

 @param dHours 后退小时数

 @return NSDate
 */
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;

/**
 当前的时间追加dMinutes分钟

 @param dMinutes 追加分钟数

 @return NSDate
 */
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;

/**
 当前的时间后退dMinutes分钟

 @param dMinutes 后退分钟数

 @return NSDate
 */
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;

/**
 获取当前的时间起始00：00：00

 @return NSDate
 */
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals

/**
 返回当前对象时间与参数传递的对象时间的相隔分钟数

 @param aDate 参数传递的对象时间

 @return NSInteger
 */
- (NSInteger) minutesAfterDate: (NSDate *) aDate;

/**
 返回当前对象时间与参数传递的对象时间的相隔分钟数

 @param aDate 参数传递的对象时间

 @return NSInteger
 */
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;

/**
 返回当前对象时间与参数传递的对象时间的相隔小时数

 @param aDate 参数传递的对象时间

 @return NSInteger
 */
- (NSInteger) hoursAfterDate: (NSDate *) aDate;

/**
 返回当前对象时间与参数传递的对象时间的相隔小时数

 @param aDate 参数传递的对象时间

 @return NSInteger
 */
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;

/**
 返回当前对象时间与参数传递的对象时间的相隔天数

 @param aDate 参数传递的对象时间

 @return NSInteger
 */
- (NSInteger) daysAfterDate: (NSDate *) aDate;

/**
 返回当前对象时间与参数传递的对象时间的相隔天数

 @param aDate 参数传递的对象时间

 @return NSInteger
 */
- (NSInteger) daysBeforeDate: (NSDate *) aDate;

// Decomposing dates

@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger weekOfYear;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;
@property (readonly) NSString *weekString;



/**
 当前的时间追加天数（实例方法）

 @param interval 追加天数

 @return NSDate
 */
- (NSDate *)relativedDateWithInterval:(NSInteger)interval;

/**
 当前的时间追加天数（类方法）

 @param interval 追加天数

 @return NSDate
 */
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval;

/**
 将NSString型的日期格式转换为对应的formate格式

 @param str     NSString日期串
 @param formate 转换格式

 @return NSDate
 */
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate;


/**
 当前时间对应的星期

 @return NSString
 */
- (NSString *)weekdayString;

/**
 以M月d日 HH:mm格式获取当前的时间字符串

 @return NSString
 */
- (NSString *)dayTimeString;

/**
 按照yyyy%@MM%@dd格式输出 其中seperator为分割符

 @param seperator 分割符

 @return NSString
 */
- (NSString *)stringWithSeperator:(NSString *)seperator;

/**
 根据format格式转换当前的时间

 @param format 转换格式

 @return NSString
 */
- (NSString *)stringWithFormat:(NSString*)format;

/**
 根据seperator区分获取格式

 @param seperator   分隔符
 @param includeYear 是否包含年

 @return NSString
 */
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear;

/**
 获取时间戳 毫秒级

 @return NSString
 */
+ (NSString *)timeStamp;

/**
 当前的时间和系统时间比较 区分显示 当天显示HH：mm 其他显示MM-dd

 @param time 时间戳

 @return NSString
 */
+ (NSString *)stringTodayShow:(NSNumber *)time;

/**
 根据时间戳转换成%@月%@日 %@:%@格式

 @param time 时间戳

 @return NSString
 */
+ (NSString *)hoursStringWithTime:(NSNumber *)time;

/**
 根据时间戳转换为朋友圈微博常用x秒前 x分钟前

 @param time 时间戳

 @return NSString
 */
+ (NSString *)timeStringWithInterval:(NSTimeInterval) time;

/**
 按格式输出时间

 @param date   传入日期
 @param format 格式

 @return NSString
 */
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;

/**
 根据时间戳获取对应的时间格式

 @param time 传入时间戳

 @return NSString
 */
+ (NSString *)hoursOrDayTimeStringWithTime:(NSNumber *)time;

/**
 获取系统时区

 @return NSTimeZone
 */
+ (NSTimeZone *)getDefaultTimeZone;
@end
