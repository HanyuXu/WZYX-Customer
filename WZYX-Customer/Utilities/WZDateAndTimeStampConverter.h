//
//  WZDateAndTimeStampConverter.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/25.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZDateAndTimeStampConverter : NSObject

+ (NSString *)convertTimeStampToDate:(NSString *)timeStamp;
+ (NSString *)convertDateToTimeStamp:(NSString *)date;

@end

NS_ASSUME_NONNULL_END
