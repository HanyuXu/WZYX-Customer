//
//  WZDateStringConverter.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/6.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZDateStringConverter.h"

@implementation WZDateStringConverter

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromDateString:(NSString *)string {
    NSDate *date = [self dateFromString:string];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [NSDate dateWithTimeInterval:interval sinceDate:date];
    return localDate;
}
+ (NSArray<NSString *> *)datePeriod:(NSString *)start EndDate:(NSString *)end {
    NSDate *startDate = [self dateFromString:start];
    NSDate *endDate = [self dateFromString:end];
    NSMutableArray<NSString *> *res = [[NSMutableArray alloc] init];
    NSDate *date = [startDate copy];
    while([[date laterDate:endDate] isEqualToDate:endDate]) {
        NSString *dateString = [self stringFromDate:date];
        [res addObject:dateString];
        date = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
    }
    return [res copy];
}
@end
