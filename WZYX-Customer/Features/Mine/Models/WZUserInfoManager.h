//
//  WZUserInfo.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/27.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZUserInfo : NSObject

@property(strong, nonatomic) NSString *userName;
@property(strong, nonatomic) NSString *gender;
@property(strong, nonatomic) NSString *imagePath;

+ (instancetype) sharedUser;
+ (BOOL) userIsLoggedIn;
+ (void) saveUserInfoWithParameters:(NSDictionary *)userInfo;
+ (void) updateUserInfoWithPrameters:(NSDictionary *)param success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void) saveImage:(UIImage *)newImage withName:(NSString *)name;

+ (void) uploadImage:(UIImage *)image withParamters:(NSDictionary *)param success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (UIImage *) userPortrait;
@end

NS_ASSUME_NONNULL_END
