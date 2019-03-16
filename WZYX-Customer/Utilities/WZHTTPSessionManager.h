//
//  WZHTTPSessionManager.h
//  WZYX-Customer
//
//  Created by 祈越 on 2019/3/6.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface WZHTTPSessionManager : NSObject

+ (AFHTTPSessionManager *)sharedManager;

@end

NS_ASSUME_NONNULL_END
