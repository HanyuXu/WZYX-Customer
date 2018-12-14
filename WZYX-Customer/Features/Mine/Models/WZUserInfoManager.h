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

+ (BOOL)userIsLoggedIn;
+ (void)initializeUserInfoWithParameters:(NSDictionary *)userInfo;
+ (void)loadUserInfo;
+ (void)saveUserInfo;
+ (UIImage *)userPortrait;
+ (void)clearCurrentUser;

+ (void)updateUserInfoWithPrameters:(NSDictionary *)param success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)uploadImage:(UIImage *)image withParamters:(NSDictionary *)param success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

@end

NS_ASSUME_NONNULL_END
