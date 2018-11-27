//
//  WZDataFormatChecker.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/23.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZDataFormatChecker : NSObject

+ (BOOL)isPhoneNumberString:(NSString *)phoneNumber;
+ (BOOL)isVerificationCodeString:(NSString *)verificationCode;

@end
