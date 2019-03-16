//
//  WZHTTPSessionManager.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/3/6.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZHTTPSessionManager.h"

@implementation WZHTTPSessionManager

static AFHTTPSessionManager *manager = nil;

+ (AFHTTPSessionManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10;
    });
    return manager;
}

@end
