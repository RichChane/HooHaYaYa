//
//  NSCalendar+ST.h
//  STCalendarDemo
//
//  Created by https://github.com/STShenZhaoliang/STCalendar on 15/12/17.
//  Copyright © 2015年 ST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (ST)


/**
 根据已有日期计算偏差之后的日期

 @param date 已有日期
 @param year 年份的偏移量，负减正加
 @param month 月份的偏移量，负减正加
 @param day 天数的偏移量，负减正加
 @return 偏移之后的日期
 */
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withYear:(int)year month:(int)month day:(int)day;

/**
 *  1.当前的日期数据元件模型
 *
 *  @return <#return value description#>
 */
+ (NSDateComponents *)currentDateComponents;

/**
 *  2.当前年
 *
 *  @return <#return value description#>
 */
+ (NSInteger)currentYear;

/**
 *  3.当前月
 *
 *  @return <#return value description#>
 */
+ (NSInteger)currentMonth;

/**
 *  4.当前天
 */
+ (NSInteger)currentDay;

/**
 *  5.当前周数
 */
+ (NSInteger)currnentWeekday;

/**
 *  5.1 获取所选年份剩余月数
 */
+ (NSInteger)getLastMonthWithSelectYear:(NSInteger)year;
/**
 *  6.获取指定年月的天数
 */
+ (NSInteger)getDaysWithYear:(NSInteger)year
                       month:(NSInteger)month;

/**
 *  7.获取指定年月的第一天的周数
 */
+ (NSInteger)getFirstWeekdayWithYear:(NSInteger)year
                               month:(NSInteger)month;
/**
 *  8.比较两个日期元件
 */
+ (NSComparisonResult)compareWithComponentsOne:(NSDateComponents *)componentsOne
                                 componentsTwo:(NSDateComponents *)componentsTwo;

/**
 *  9.获取两个日期元件之间的日期元件
 */
+ (NSMutableArray *)arrayComponentsWithComponentsOne:(NSDateComponents *)componentsOne
                                       componentsTwo:(NSDateComponents *)componentsTwo;
/**
 *  10.字符串转日期元件 字符串格式为：yy-MM-dd
 */
+ (NSDateComponents *)dateComponentsWithString:(NSString *)String;
@end
