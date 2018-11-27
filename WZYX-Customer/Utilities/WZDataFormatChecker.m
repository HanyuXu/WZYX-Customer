//
//  WZDataFormatChecker.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/23.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZDataFormatChecker.h"

@implementation WZDataFormatChecker

+ (BOOL)isPhoneNumberString:(NSString *)phoneNumber {
    // 电信号段:133/153/180/181/189/177
    // 联通号段:130/131/132/155/156/185/186/145/176
    // 移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    // 虚拟运营商:170
    NSString *legalPhoneNumber = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", legalPhoneNumber];
    return [predicate evaluateWithObject:phoneNumber];
}

+ (BOOL)isVerificationCodeString:(NSString *)verificationCode {
    NSString *legalVerificationCode = @"^\\d{6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", legalVerificationCode];
    return [predicate evaluateWithObject:verificationCode];
}

@end
