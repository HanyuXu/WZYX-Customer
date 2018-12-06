//
//  WZUser.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/1.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZUser : NSObject

@property(copy, nonatomic) NSString *userName;
@property(copy, nonatomic) NSString *gender;
@property(copy, nonatomic) NSString *imageName;
@property(copy, nonatomic) NSString *fileName;
@property(copy, nonatomic) NSString *imageURL;
@property(copy, nonatomic) NSString *phoneNumber;
+ (instancetype)sharedUser;
@end

NS_ASSUME_NONNULL_END
