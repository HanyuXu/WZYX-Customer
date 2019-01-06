//
//  WZDateStringConverter.h
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/6.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZDateStringConverter : NSObject

+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
