//
//  WZUserInfoManager.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/27.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import <AFNetworking/AFImageDownloader.h>
#import <AFNetworking.h>
#import "WZUserInfoManager.h"
#import "WZUser.h"

@interface WZUserInfoManager ()
@end

@implementation WZUserInfoManager


#pragma mark - utility

// get "Document" directory
+ (NSString *)documentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    return paths[0];
}

+ (NSString *)imagePathWithImageName:(NSString *)imageName{
    return [[self documentPath] stringByAppendingPathComponent:imageName];
}

+ (NSString *)filePathWithFileName:(NSString *)FileName{
    return [[self documentPath] stringByAppendingPathComponent:FileName];
}

// judge if user is logged in
+ (BOOL)userIsLoggedIn {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *filePath = [[self documentPath] stringByAppendingPathComponent:@"currentUser.plist"];
    return [manager fileExistsAtPath:filePath];
}


#pragma mark - initialize user information

// initialize user information with a dictionary parsed from json
+ (void)initializeUserInfoWithParameters:(NSDictionary *)userInfo {
    NSString *gender, *userName, *imageName, *fileName, *imageURL, *phoneNumber;
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
    
    imageName = [NSString stringWithFormat:@"用户%@.jpg",userInfo[@"userId"]];
    fileName = [NSString stringWithFormat:@"用户%@.plist",userInfo[@"userId"]];
    imageURL = userInfo[@"photo"];
    phoneNumber = userInfo[@"phoneNumber"];
    WZUser *currentUser = [WZUser sharedUser];
    currentUser.userName = userName;
    currentUser.gender = gender;
    currentUser.imageName = imageName;
    currentUser.fileName = fileName;
    currentUser.imageURL = imageURL;
    currentUser.phoneNumber = phoneNumber;
    [self saveUserInfo];
}

// load current user's information
+ (void)loadUserInfo {
    NSString *filePath = [[self documentPath] stringByAppendingPathComponent:@"currentUser.plist"];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    WZUser *currentUser = [WZUser sharedUser];
    currentUser.userName = userInfo[@"userName"];
    currentUser.gender = userInfo[@"gender"];
    currentUser.imageName = userInfo[@"imageName"];
    currentUser.fileName = userInfo[@"fileName"];
    currentUser.imageURL = userInfo[@"imageURL"];
    currentUser.phoneNumber = userInfo[@"phoneNumber"];
}

#pragma mark - save userInfomation

+ (void)saveUserInfo {
    WZUser *user = [WZUser sharedUser];
    NSDictionary *userInfo = @{@"userName":user.userName, @"gender":user.gender, @"imageName":user.imageName, @"fileName":user.fileName, @"imageURL":user.imageURL, @"phoneNumber":user.phoneNumber};
    NSString *path = [self documentPath];
    NSString *userInfoFileName = [self filePathWithFileName:userInfo[@"fileName"]];
    NSString *currentUserInfoFileName = [path stringByAppendingPathComponent:@"currentUser.plist"];
    [userInfo writeToFile:userInfoFileName atomically:YES];
    [userInfo writeToFile:currentUserInfoFileName atomically:YES];
}

+ (void)saveImage:(UIImage *)newImage{
    NSString *imagePath = [self imagePathWithImageName:[WZUser sharedUser].imageName];
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.7);
    [imageData writeToFile:imagePath atomically:YES];
}

#pragma mark - obtain user information

// 获取用户头像

+ (void)downloadPortrait {
    AFImageDownloader *downloader = [AFImageDownloader defaultInstance];
    NSString *imageURLString = [[WZUser sharedUser] imageURL];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    [downloader downloadImageForURLRequest:request success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
        NSLog(@"success");
        [self saveImage:responseObject];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
}

+ (UIImage *)userPortrait {
    if (![self userIsLoggedIn]) {
        return [UIImage imageNamed:@"Person"];
    }
    WZUser *user = [WZUser sharedUser];
    NSString *imagePath = [self imagePathWithImageName:user.imageName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:imagePath]) {
        UIImage *image=[[UIImage alloc]initWithContentsOfFile:imagePath];
        CGSize size = CGSizeMake(60, 60);
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
    else return [UIImage imageNamed:@"Person"];
}

#pragma mark - update user information

// update user's information such as name, gender etc.
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

// upload portrait
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
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        [self saveImage:image];
        [WZUser sharedUser].imageURL = dic[@"msg"];
        [self saveUserInfo];
        successBlock();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后再试");
    }];
}

#pragma mark - user logout
+ (void) clearCurrentUser {
    NSString *path = [[self documentPath] stringByAppendingPathComponent:@"currentUser.plist"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}
@end
