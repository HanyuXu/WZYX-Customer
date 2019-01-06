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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:string];
}

@end
