//
//  WZActivityManager.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/25.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WZActivity;

@interface WZActivityManager : NSObject

// 根据定位获取附近活动
+ (void)downLoadActivityListWithSortType:(NSUInteger) sortType
                                 success:(void (^_Nullable)(NSMutableArray<WZActivity*>* activities)) successBlock
                                 faliure:(void (^_Nullable)(void)) failureBlock;

// 搜索附近活动
+ (void)searchActivityNearBy:(NSString *)str
                    success:(void (^_Nullable)(NSMutableArray<WZActivity*>*)) successBlock
                    failure:(void (^_Nullable)(void)) failureBlock;
@end

NS_ASSUME_NONNULL_END
