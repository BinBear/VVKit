//
//  NSDate+VinKit.m
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import "NSDate+VinKit.h"

NSInteger const D_MINUTE  = 60;
NSInteger const D_HOUR    = 3600;
NSInteger const D_DAY     = 86400;
NSInteger const D_WEEK    = 604800;
NSInteger const D_YEAR    = 31556926;

NSCalendarUnit const CalendarUnit_FLAGS = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitYearForWeekOfYear);

@implementation NSDate (VinKit)

#pragma mark - 相对日期
/// 明天
+ (NSDate *)vv_dateTomorrow {
    return [NSDate vv_dateWithDaysFromNow:1];
}
/// 昨天
+ (NSDate *)vv_dateYesterday {
    return [NSDate vv_dateWithDaysBeforeNow:1];
}
/// 今天后几天
+ (NSDate *)vv_dateWithDaysFromNow:(NSInteger)days {
    return [[NSDate date] vv_dateByAddingDays:days];
}
/// 今天前几天
+ (NSDate *)vv_dateWithDaysBeforeNow:(NSInteger)days {
    return [[NSDate date] vv_dateBySubtractingDays:days];
}
/// 当前小时后hours小时
+ (NSDate *)vv_dateWithHoursFromNow:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
/// 当前小时前hours小时
+ (NSDate *)vv_dateWithHoursBeforeNow:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
/// 当前分钟后minutes分钟
+ (NSDate *)vv_dateWithMinutesFromNow:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
/// 当前分钟前minutes分钟
+ (NSDate *)vv_dateWithMinutesBeforeNow:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}


#pragma mark - 比较日期
/// 初始化日历实例
+ (NSCalendar *)vv_currentCalendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}
/// 比较年月日是否相等
- (BOOL)vv_isEqualToDateIgnoringTime:(NSDate *)date {
    NSDateComponents *components1 = [[NSDate vv_currentCalendar] components:CalendarUnit_FLAGS fromDate:self];
    NSDateComponents *components2 = [[NSDate vv_currentCalendar] components:CalendarUnit_FLAGS fromDate:date];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}
/// 是否是今天
- (BOOL)vv_isToday {
    return [self vv_isEqualToDateIgnoringTime:[NSDate date]];
}
/// 是否是明天
- (BOOL)vv_isTomorrow {
    return [self vv_isEqualToDateIgnoringTime:[NSDate vv_dateTomorrow]];
}
/// 是否是昨天
- (BOOL)vv_isYesterday {
    return [self vv_isEqualToDateIgnoringTime:[NSDate vv_dateYesterday]];
}
/// 是否是同一周
- (BOOL)vv_isSameWeekAsDate:(NSDate *)date {
    NSDateComponents *components1 = [[NSDate vv_currentCalendar] components:CalendarUnit_FLAGS fromDate:self];
    NSDateComponents *components2 = [[NSDate vv_currentCalendar] components:CalendarUnit_FLAGS fromDate:date];
    
    if (components1.weekOfYear != components2.weekOfYear) { return NO; }
    return (fabs([self timeIntervalSinceDate:date]) < D_WEEK);
}
/// 是否是本周
- (BOOL)vv_isThisWeek {
    return [self vv_isSameWeekAsDate:[NSDate date]];
}
/// 是否是本周的下周
- (BOOL)vv_isNextWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self vv_isSameWeekAsDate:newDate];
}
/// 是否是本周的上周
- (BOOL)vv_isLastWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self vv_isSameWeekAsDate:newDate];
}
/// 是否是同一月
- (BOOL)vv_isSameMonthAsDate:(NSDate *)date {
    NSDateComponents *components1 = [[NSDate vv_currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate vv_currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}
/// 是否是本月
- (BOOL)vv_isThisMonth {
    return [self vv_isSameMonthAsDate:[NSDate date]];
}
/// 是否是本月的下月
- (BOOL)vv_isNextMonth {
    return [self vv_isSameMonthAsDate:[[NSDate date] vv_dateByAddingMonths:1]];
}
/// 是否是本月的上月
- (BOOL)vv_isLastMonth {
    return [self vv_isSameMonthAsDate:[[NSDate date] vv_dateBySubtractingMonths:1]];
}
/// 是否是同一年
- (BOOL)vv_isSameYearAsDate:(NSDate *)date {
    NSDateComponents *components1 = [[NSDate vv_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate vv_currentCalendar] components:NSCalendarUnitYear fromDate:date];
    return (components1.year == components2.year);
}
/// 是否是今年
- (BOOL)vv_isThisYear {
    return [self vv_isSameYearAsDate:[NSDate date]];
}
/// 是否是今年的下一年
- (BOOL)vv_isNextYear {
    NSDateComponents *components1 = [[NSDate vv_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate vv_currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year + 1));
}
/// 是否是今年的上一年
- (BOOL)vv_isLastYear {
    NSDateComponents *components1 = [[NSDate vv_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate vv_currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year - 1));
}
/// 是否早于此日期
- (BOOL)vv_isEarlierThanDate:(NSDate *)date {
    return ([self compare:date] == NSOrderedAscending);
}
/// 是否晚于此日期
- (BOOL)vv_isLaterThanDate:(NSDate *)date {
    return ([self compare:date] == NSOrderedDescending);
}
/// 判断是否是润年
- (BOOL)isLeapYear {
    NSUInteger year = [self vv_year];
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }
    return NO;
}


#pragma mark - 调整时间
/// 增加years年
- (NSDate *)vv_dateByAddingYears:(NSInteger)years {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:years];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
/// 减少years年
- (NSDate *)vv_dateBySubtractingYears:(NSInteger)years {
    return [self vv_dateByAddingYears:(years * -1)];
}
/// 增加months月
- (NSDate *)vv_dateByAddingMonths:(NSInteger)months {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:months];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
/// 减少months月
- (NSDate *)vv_dateBySubtractingMonths:(NSInteger)months {
    return [self vv_dateByAddingMonths:(months * -1)];
}
/// 增加days天
- (NSDate *)vv_dateByAddingDays:(NSInteger)days {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:days];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
/// 减少days天
- (NSDate *)vv_dateBySubtractingDays:(NSInteger)days {
    return [self vv_dateByAddingDays:(days * -1)];
}
/// 增加hours小时
- (NSDate *)vv_dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
/// 减少hours小时
- (NSDate *)vv_dateBySubtractingHours:(NSInteger)hours {
    return [self vv_dateByAddingHours:(hours * -1)];
}
/// 增加minutes分钟
- (NSDate *)vv_dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
/// 减少minutes分钟
- (NSDate *)vv_dateBySubtractingMinutes:(NSInteger)minutes {
    return [self vv_dateByAddingMinutes:(minutes * -1)];
}


#pragma mark - 时间间隔
/// 比date晚多少分钟
- (NSInteger)vv_minutesAfterDate:(NSDate *)date {
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger)(ti / D_MINUTE);
}
/// 比date早多少分钟
- (NSInteger)vv_minutesBeforeDate:(NSDate *)date {
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_MINUTE);
}
/// 比date晚多少小时
- (NSInteger)vv_hoursAfterDate:(NSDate *)date {
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger)(ti / D_HOUR);
}
/// 比date早多少小时
- (NSInteger)vv_hoursBeforeDate:(NSDate *)date {
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_HOUR);
}
/// 比date晚多少天
- (NSInteger)vv_daysAfterDate:(NSDate *)date {
    NSTimeInterval ti = [self timeIntervalSinceDate:date];
    return (NSInteger)(ti / D_DAY);
}
/// 比date早多少天
- (NSInteger)vv_daysBeforeDate:(NSDate *)date {
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_DAY);
}
/// 与date间隔几天
- (NSInteger)vv_distanceDaysToDate:(NSDate *)date {
    NSDateComponents *components = [[NSDate vv_currentCalendar] components:NSCalendarUnitDay fromDate:self toDate:date options:0];
    return components.day;
}
/// 与date间隔几月
- (NSInteger)vv_distanceMonthsToDate:(NSDate *)date {
    NSDateComponents *components = [[NSDate vv_currentCalendar] components:NSCalendarUnitMonth fromDate:self toDate:date options:0];
    return components.month;
}
/// 与date间隔几年
- (NSInteger)vv_distanceYearsToDate:(NSDate *)date {
    NSDateComponents *components = [[NSDate vv_currentCalendar] components:NSCalendarUnitYear fromDate:self toDate:date options:0];
    return components.year;
}


#pragma mark - 日期信息
/// 获取某个日期的开始时间戳，精确到毫秒
- (NSString *)vv_startOfDate {
    NSCalendar *calendar = [NSDate vv_currentCalendar];
    // 获取该日期的开始时间（00:00:00）
    NSDateComponents *startOfDayComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    [startOfDayComponents setHour:0];
    [startOfDayComponents setMinute:0];
    [startOfDayComponents setSecond:0];
    NSDate *startOfDay = [calendar dateFromComponents:startOfDayComponents];
    NSTimeInterval startTimestamp = [startOfDay timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%.0f", startTimestamp];;
}
/// 获取某个日期的结束时间戳，精确到毫秒
- (NSString *)vv_endOfDate {
    NSCalendar *calendar = [NSDate vv_currentCalendar];
    // 获取该日期的结束时间（23:59:59）
    NSDateComponents *endOfDayComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    [endOfDayComponents setHour:23];
    [endOfDayComponents setMinute:59];
    [endOfDayComponents setSecond:59];
    NSDate *endOfDay = [calendar dateFromComponents:endOfDayComponents];
    NSTimeInterval endTimestamp = [endOfDay timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%.0f", endTimestamp];;
}
/// 获取日期中的年
- (NSUInteger)vv_year {
    NSDateComponents *dayComponents = [[NSDate vv_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    return [dayComponents year];
}
/// 获取日期中的月
- (NSUInteger)vv_month {
    NSDateComponents *dayComponents = [[NSDate vv_currentCalendar] components:NSCalendarUnitMonth fromDate:self];
    return [dayComponents month];
}
/// 获取日期中的天
- (NSUInteger)vv_day {
    NSDateComponents *dayComponents = [[NSDate vv_currentCalendar] components:NSCalendarUnitDay fromDate:self];
    return [dayComponents day];
}
/// 获取日期中的小时
- (NSUInteger)vv_hour {
    NSDateComponents *dayComponents = [[NSDate vv_currentCalendar] components:NSCalendarUnitHour fromDate:self];
    return [dayComponents hour];
}
/// 获取日期中的分钟
- (NSUInteger)vv_minute {
    NSDateComponents *dayComponents = [[NSDate vv_currentCalendar] components:NSCalendarUnitMinute fromDate:self];
    return [dayComponents minute];
}
/// 获取日期中的秒数
- (NSUInteger)vv_second {
    NSDateComponents *dayComponents = [[NSDate vv_currentCalendar] components:NSCalendarUnitSecond fromDate:self];
    return [dayComponents second];
}
/// 获取格式化为YYYY-MM-dd格式的日期字符串
- (NSString *)vv_formatYMD {
    return [NSString stringWithFormat:@"%lu-%02lu-%02lu",[self vv_year],[self vv_month], [self vv_day]];
}
/// yyyy-MM-dd格式的字符串
+ (NSString *)vv_ymdFormat {
    return @"yyyy-MM-dd";
}
/// HH:mm:ss格式的字符串
+ (NSString *)vv_hmsFormat {
    return @"HH:mm:ss";
}
/// yyyy-MM-dd/HH:mm:ss格式的字符串
+ (NSString *)vv_ymdHmsFormat {
    return [NSString stringWithFormat:@"%@ %@", [NSDate vv_ymdFormat], [NSDate vv_hmsFormat]];
}


@end
