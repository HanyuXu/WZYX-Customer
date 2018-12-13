//
//  WZUser.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/1.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZUser.h"

@implementation WZUser

static WZUser* user = nil;

+ (instancetype) sharedUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[self alloc] init];
    });
    return user;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [super allocWithZone:zone];
    });
    return user;
}

@end
