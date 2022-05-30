//
//  NSDate+VinKit.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (VinKit)

#pragma mark - 相对日期
/// 明天
+ (NSDate *)vv_dateTomorrow;
/// 昨天
+ (NSDate *)vv_dateYesterday;
/// 今天后几天
+ (NSDate *)vv_dateWithDaysFromNow:(NSInteger)days;
/// 今天前几天
+ (NSDate *)vv_dateWithDaysBeforeNow:(NSInteger)days;
/// 当前小时后hours小时
+ (NSDate *)vv_dateWithHoursFromNow:(NSInteger)hours;
/// 当前小时前hours小时
+ (NSDate *)vv_dateWithHoursBeforeNow:(NSInteger)hours;
/// 当前分钟后minutes分钟
+ (NSDate *)vv_dateWithMinutesFromNow:(NSInteger)minutes;
/// 当前分钟前minutes分钟
+ (NSDate *)vv_dateWithMinutesBeforeNow:(NSInteger)minutes;


#pragma mark - 比较日期
/// 比较年月日是否相等
- (BOOL)vv_isEqualToDateIgnoringTime:(NSDate *)date;
/// 是否是今天
- (BOOL)vv_isToday;
/// 是否是明天
- (BOOL)vv_isTomorrow;
/// 是否是昨天
- (BOOL)vv_isYesterday;
/// 是否是同一周
- (BOOL)vv_isSameWeekAsDate:(NSDate *)date;
/// 是否是本周
- (BOOL)vv_isThisWeek;
/// 是否是本周的下周
- (BOOL)vv_isNextWeek;
/// 是否是本周的上周
- (BOOL)vv_isLastWeek;
/// 是否是同一月
- (BOOL)vv_isSameMonthAsDate:(NSDate *)date;
/// 是否是本月
- (BOOL)vv_isThisMonth;
/// 是否是本月的下月
- (BOOL)vv_isNextMonth;
/// 是否是本月的上月
- (BOOL)vv_isLastMonth;
/// 是否是同一年
- (BOOL)vv_isSameYearAsDate:(NSDate *)date;
/// 是否是今年
- (BOOL)vv_isThisYear;
/// 是否是今年的下一年
- (BOOL)vv_isNextYear;
/// 是否是今年的上一年
- (BOOL)vv_isLastYear;
/// 是否早于此日期
- (BOOL)vv_isEarlierThanDate:(NSDate *)date;
/// 是否晚于此日期
- (BOOL)vv_isLaterThanDate:(NSDate *)date;
/// 判断是否是润年
- (BOOL)isLeapYear;


#pragma mark - 调整时间
/// 增加years年
- (NSDate *)vv_dateByAddingYears:(NSInteger)years;
/// 减少years年
- (NSDate *)vv_dateBySubtractingYears:(NSInteger)years;
/// 增加months月
- (NSDate *)vv_dateByAddingMonths:(NSInteger)months;
/// 减少months月
- (NSDate *)vv_dateBySubtractingMonths:(NSInteger)months;
/// 增加days天
- (NSDate *)vv_dateByAddingDays:(NSInteger)days;
/// 减少days天
- (NSDate *)vv_dateBySubtractingDays:(NSInteger)days;
/// 增加hours小时
- (NSDate *)vv_dateByAddingHours:(NSInteger)hours;
/// 减少hours小时
- (NSDate *)vv_dateBySubtractingHours:(NSInteger)hours;
/// 增加minutes分钟
- (NSDate *)vv_dateByAddingMinutes:(NSInteger)minutes;
/// 减少minutes分钟
- (NSDate *)vv_dateBySubtractingMinutes:(NSInteger)minutes;


#pragma mark - 时间间隔
/// 比date晚多少分钟
- (NSInteger)vv_minutesAfterDate:(NSDate *)date;
/// 比date早多少分钟
- (NSInteger)vv_minutesBeforeDate:(NSDate *)date;
/// 比date晚多少小时
- (NSInteger)vv_hoursAfterDate:(NSDate *)date;
/// 比date早多少小时
- (NSInteger)vv_hoursBeforeDate:(NSDate *)date;
/// 比date晚多少天
- (NSInteger)vv_daysAfterDate:(NSDate *)date;
/// 比date早多少天
- (NSInteger)vv_daysBeforeDate:(NSDate *)date;
/// 与date间隔几天
- (NSInteger)vv_distanceDaysToDate:(NSDate *)date;
/// 与date间隔几月
- (NSInteger)vv_distanceMonthsToDate:(NSDate *)date;
/// 与date间隔几年
- (NSInteger)vv_distanceYearsToDate:(NSDate *)date;


#pragma mark - 日期信息
/// 获取日期中的年
- (NSUInteger)vv_year;
/// 获取日期中的月
- (NSUInteger)vv_month;
/// 获取日期中的天
- (NSUInteger)vv_day;
/// 获取日期中的小时
- (NSUInteger)vv_hour;
/// 获取日期中的分钟
- (NSUInteger)vv_minute;
/// 获取日期中的秒数
- (NSUInteger)vv_second;
/// 获取格式化为YYYY-MM-dd格式的日期字符串
- (NSString *)vv_formatYMD;
/// yyyy-MM-dd格式的字符串
+ (NSString *)vv_ymdFormat;
/// HH:mm:ss格式的字符串
+ (NSString *)vv_hmsFormat;
/// yyyy-MM-dd/HH:mm:ss格式的字符串
+ (NSString *)vv_ymdHmsFormat;


@end

NS_ASSUME_NONNULL_END
