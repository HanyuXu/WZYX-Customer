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
        NSDictionary *userInfo = (NSDictionary *)(responseDictionary[@"data"]);
        if ([responseDictionary[@"status"] intValue] == 0) {
            NSString *gender, *userName;
            if (userInfo[@"gender"] == [NSNull null]) { // strange 
                gender = @"未设定";
            } else {
                gender = ([userInfo[@"gender"] intValue] == 0) ? @"男" : @"女";
            }
            if (userInfo[@"userName"] == nil) {
                userName = [NSString stringWithFormat:@"用户%@",userInfo[@"userId"]];
            } else {
                userName = userInfo[@"userName"];
            }
            NSNumber *userId = [NSNumber numberWithInteger:[userInfo[@"userId"] intValue]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:phoneNumber forKey:@"phoneNumber"];
            [userDefaults setObject:responseDictionary[@"msg"] forKey:@"authToken"];
            [userDefaults setObject:gender forKey:@"gender"];
            [userDefaults  setObject:userId forKey:@"userId"];
            [userDefaults setObject:userName forKey:@"userName"];
            
            successBlock();
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)logoutSuccess:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"authToken"]) {
        failureBlock(@"用户未登录");
        return;
    }
    NSDictionary *paramsDictionary = @{@"authToken" : [userDefaults objectForKey:@"authToken"]};
    [manager POST:@"http://120.79.10.184:8080/mobile/user/logout" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            [userDefaults removeObjectForKey:@"phoneNumber"];
            [userDefaults removeObjectForKey:@"authToken"];
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
