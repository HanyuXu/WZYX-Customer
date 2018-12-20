//
//  WZUserInfoManager.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/27.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZUserInfoManager.h"
#import "WZUser.h"

#import <AFNetworking/AFImageDownloader.h>
#import <AFNetworking.h>

#define SANDBOX_DOCUMENT_PATH   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define DEFAULT_FILE_MANAGER    [NSFileManager defaultManager]

@interface WZUserInfoManager ()

@end

@implementation WZUserInfoManager

+ (BOOL)userIsLoggedIn {
    // 待实现：后台应提供心跳接口，验证登录状态是否过期
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"authToken"] != nil) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)initializeUserInfoWithParameters:(NSDictionary *)userInfo {
    WZUser *sharedUser = [WZUser sharedUser];
    if (userInfo[@"userName"] == [NSNull null]) {
        sharedUser.userName = [NSString stringWithFormat:@"用户%@", userInfo[@"userId"]];
    } else {
        sharedUser.userName = userInfo[@"userName"];
    }
    if (userInfo[@"gender"] == [NSNull null]) {
        sharedUser.gender = @"未设定";
    } else {
        sharedUser.gender = ([userInfo[@"gender"] intValue] == 0) ? @"男" : @"女";
    }
    sharedUser.imageName = [NSString stringWithFormat:@"用户%@.jpg", userInfo[@"userId"]];
    sharedUser.fileName = [NSString stringWithFormat:@"用户%@.plist", userInfo[@"userId"]];
    sharedUser.imageURL = userInfo[@"photo"];
    sharedUser.phoneNumber = userInfo[@"phoneNumber"];
    [self saveUserInfo];
}

+ (void)loadUserInfo {
    NSString *filePath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"CurrentUser.plist"];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    WZUser *currentUser = [WZUser sharedUser];
    currentUser.userName = userInfo[@"userName"];
    currentUser.gender = userInfo[@"gender"];
    currentUser.imageName = userInfo[@"imageName"];
    currentUser.fileName = userInfo[@"fileName"];
    currentUser.imageURL = userInfo[@"imageURL"];
    currentUser.phoneNumber = userInfo[@"phoneNumber"];
}

+ (void)saveUserInfo {
    WZUser *user = [WZUser sharedUser];
    NSDictionary *userInfo = @{@"userName":user.userName, @"gender":user.gender, @"imageName":user.imageName, @"fileName":user.fileName, @"imageURL":user.imageURL, @"phoneNumber":user.phoneNumber};
    NSString *currentUserInfoFileName = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"CurrentUser.plist"];
    [userInfo writeToFile:currentUserInfoFileName atomically:YES];
}

+ (UIImage *)userPortrait {
    if (![self userIsLoggedIn]) {
        return [UIImage imageNamed:@"Person"];
    }
    WZUser *user = [WZUser sharedUser];
    NSString *imagePath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:user.imageName];
    if ([DEFAULT_FILE_MANAGER fileExistsAtPath:imagePath]) {
        return [UIImage imageWithContentsOfFile:imagePath];
    } else {
        [WZUserInfoManager downloadPortrait];
        return [UIImage imageNamed:@"Person"];
    }
}

+ (void)clearCurrentUser {
    NSString *path = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"CurrentUser.plist"];
    [DEFAULT_FILE_MANAGER removeItemAtPath:path error:nil];
}

+ (void)updateUserInfoWithPrameters:(NSDictionary *)param success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://120.79.10.184:8080/mobile/user/update_information" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (void)uploadImage:(UIImage *)image withParamters:(NSDictionary *)param success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",                                  
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"http://120.79.10.184:8080/mobile/user/update_photo"  parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image,0.7);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        [self savePortrait:image];
        [WZUser sharedUser].imageURL = dic[@"msg"];
        [self saveUserInfo];
        successBlock();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后再试");
    }];
}

#pragma mark - PrivateMethods

+ (void)downloadPortrait {
    AFImageDownloader *downloader = [AFImageDownloader defaultInstance];
    NSString *imageURLString = [[WZUser sharedUser] imageURL];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    [downloader downloadImageForURLRequest:request success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
        [WZUserInfoManager savePortrait:responseObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldLoadUserInfo" object:nil];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
    }];
}

+ (void)savePortrait:(UIImage *)portrait {
    NSString *imagePath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:[WZUser sharedUser].imageName];
    NSData *imageData = UIImageJPEGRepresentation(portrait, 0.7);
    [imageData writeToFile:imagePath atomically:YES];
}

@end
