//
//  WZLogin.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/24.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZLogin.h"
#import "AFNetworking.h"

@implementation WZLogin

+ (void)loginWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramsDictionary = @{@"phoneNumber" : phoneNumber, @"password" : password};
    [manager POST:@"http://120.79.10.184:8080/mobile/user/login" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:phoneNumber forKey:@"phoneNumber"];
            [userDefaults setObject:responseDictionary[@"msg"] forKey:@"authToken"];
            successBlock();
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)sendVerificationCodeToPhoneNumber:(NSString *)phoneNumber success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramsDictionary = @{@"phoneNumber" : phoneNumber};
    [manager POST:@"http://120.79.10.184:8080/mobile/user/sendVerificationCode" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            successBlock();
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)registerWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password verificationCode:(NSString *)verificationCode success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramsDictionary = @{@"phoneNumber" : phoneNumber, @"password" : password, @"verificationCode" : verificationCode};
    [manager POST:@"http://120.79.10.184:8080/mobile/user/register" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            successBlock();
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)resetPasswordWithPhoneNumber:(NSString *)phoneNumber verificationCode:(NSString *)verificationCode newPassword:(NSString *)newPassword success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramsDictionary = @{@"phoneNumber" : phoneNumber, @"verificationCode" : verificationCode, @"newPassword" : newPassword};
    [manager POST:@"http://120.79.10.184:8080/mobile/user/forget_reset_password" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            successBlock();
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)modifyPassword:(NSString *)password toNewPassword:(NSString *)newPassword success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
    NSDictionary *paramsDictionary = @{@"authToken" : authToken, @"oldPassword" : password, @"newPassword" : newPassword};
    [manager POST:@"http://120.79.10.184:8080/mobile/user/reset_password" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            successBlock();
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

@end
