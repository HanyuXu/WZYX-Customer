//
//  WZDataFormatChecker.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/23.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZDataFormatChecker : NSObject

+ (BOOL)isPhoneNumberString:(NSString *)phoneNumber;
+ (BOOL)isVerificationCodeString:(NSString *)verificationCode;

@end

NS_ASSUME_NONNULL_END
