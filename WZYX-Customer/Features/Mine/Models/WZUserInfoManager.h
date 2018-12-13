//
//  WZUserInfoManager.h
//  WZYX-Customer
//  Created by 冯夏巍 on 2018/11/27.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZUserInfoManager : NSObject

@property(strong, nonatomic) NSString *userName;
@property(strong, nonatomic) NSString *gender;
@property(strong, nonatomic) NSString *imagePath;

+ (void)downloadPortrait;
+ (void)loadUserInfo;
+ (BOOL)userIsLoggedIn;
+ (void)initializeUserInfoWithParameters:(NSDictionary *)userInfo;
+ (void)updateUserInfoWithPrameters:(NSDictionary *)param success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)saveImage:(UIImage *)newImage;

+ (void)uploadImage:(UIImage *)image withParamters:(NSDictionary *)param success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (UIImage *)userPortrait;
+ (void)saveUserInfo;
+ (void)clearCurrentUser;

@end

NS_ASSUME_NONNULL_END
