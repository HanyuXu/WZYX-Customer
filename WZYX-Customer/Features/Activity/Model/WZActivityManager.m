//
//  WZActivityManager.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/25.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZActivityManager.h"
#import <AFNetworking.h>
#import "WZActivity.h"

@implementation WZActivityManager

+ (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}

+ (void)downLoadActivityListWithSortType:(NSUInteger) sortType
                                   success:(void (^_Nullable)(NSMutableArray<WZActivity*>*))successBlock
                                   faliure:(void (^_Nullable)(void))failureBlock{
    NSDictionary *param = @{@"pcate":@0, @"psort":@0, @"latitude":@100.0, @"longgitude":@100, @"distance":@5000.0, @"pageNumber": @1, @"pageSize": @10 };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableArray<WZActivity *> *activities = [[NSMutableArray alloc] init];
    [manager POST:@"http://120.79.10.184:8080/product/list" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = ((NSDictionary* )responseObject)[@"data"];
        NSDictionary *activityDict = (NSDictionary *)(dict[@"list"]);
        for(id d in activityDict){
            WZActivity *activity = [[WZActivity alloc] initWithDictionary:(NSDictionary *)d];
            NSLog(@"add!");
            [activities addObject:activity];
        }
        successBlock(activities);
        NSLog(@"%lu", activities.count);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"faliure!");
        failureBlock();
    }];
}

// 搜索附近活动
+(void)searchActivityNearBy:(NSString *)str
                    success:(void (^_Nullable)(NSMutableArray<WZActivity*>*))successBlock
                    failure:(void (^_Nullable)(void))failureBlock {
    failureBlock();
}

@end
