//
//  WZLogin.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/24.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZLogin : NSObject

+ (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)logoutSuccess:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)sendVerificationCodeToPhoneNumber:(NSString *)phoneNumber success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)registerWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password verificationCode:(NSString *)verificationCode success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)resetPasswordWithPhoneNumber:(NSString *)phoneNumber verificationCode:(NSString *)verificationCode newPassword:(NSString *)newPassword success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)modifyPassword:(NSString *)password toNewPassword:(NSString *)newPassword success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

@end

NS_ASSUME_NONNULL_END
