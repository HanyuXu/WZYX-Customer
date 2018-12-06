//
//  WZUserInfo.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/27.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZUserInfo.h"
#import <AFNetworking.h>

@interface WZUserInfo ()
@end

@implementation WZUserInfo

static WZUserInfo *_sharedUser;

+ (instancetype) sharedUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUser = [[self alloc] init];
    }) ;
    return _sharedUser;
}
//保存用户信息
+ (void)saveUserInfoWithParameters:(NSDictionary *)userInfo {
    NSString *gender, *userName, *imagePath;
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
}

+ (BOOL) userIsLoggedIn {
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]) {
        return YES;
    }
    return NO;
}
//更新用户信息
+ (void)updateUserInfoWithPrameters:(NSDictionary *)param success:(void (^)(void))successBlock
                       failure:(void (^)(NSString *userInfo))failureBlock {
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

//保存用户头像
+ (void) saveImage:(UIImage *)newImage withName:(NSString *)name {
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.7);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:YES];
}

//头像上传
+(void)uploadImage:(UIImage *)image withParamters:(NSDictionary *)param success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock{
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
        successBlock();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failureBlock(@"服务器未响应，请稍后再试");
    }];
}
// 获取用户头像
+ (UIImage *)userPortrait{
    NSNumber *userId = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *name= [NSString stringWithFormat:@"userimage%lu",userId.integerValue];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:fullPath]) {
        UIImage *image=[[UIImage alloc]initWithContentsOfFile:fullPath];
        CGSize size = CGSizeMake(60, 60);
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
    return [UIImage imageNamed:@"Person"];
}
@end
