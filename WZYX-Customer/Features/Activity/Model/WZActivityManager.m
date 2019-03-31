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

+ (void)downLoadActivityListWithLatitude:(double) latitude
                               Longitude:(double) longitude
                                Category:(NSUInteger) category
                                SortType:(WZActivitySortType) sortType
                              PageNumber:(NSUInteger) pageNumber
                                 success:(void (^_Nullable)(NSMutableArray<WZActivity*>* activities, BOOL hasNextPage)) successBlock
                                 faliure:(void (^_Nullable)(void)) failureBlock {
  NSDictionary *param = @{
    @"p_cate" : [NSNumber numberWithUnsignedInteger:category],
    @"p_sort" : [NSNumber numberWithUnsignedInteger:sortType],
    @"latitude" : [NSNumber numberWithDouble:30],
    @"longgitude" : [NSNumber numberWithDouble:20],
    @"distance" : @500000000.0,
    @"pageNumber" : [NSNumber numberWithUnsignedInteger:pageNumber],
    @"pageSize" : @10
  };
    
  AFHTTPSessionManager *manager = [self sharedManager];
  NSMutableArray<WZActivity *> *activities = [[NSMutableArray alloc] init];
    [manager POST:@"http://120.79.10.184:8080/product/list"
      parameters:param
      progress:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nullable responseObject) {
          NSLog(@"%@", responseObject);
          BOOL hasNextPage;
          NSDictionary *dict = ((NSDictionary *)responseObject)[@"data"];
          NSUInteger boolValue = [dict[@"hasNextPage"] unsignedIntegerValue];
          NSDictionary *activityDict = (NSDictionary *)(dict[@"list"]);
          if (boolValue != 0) {
              hasNextPage = YES;
          } else {
              hasNextPage = NO;
          }
         
          for (id d in activityDict) {
            WZActivity *activity =
                [[WZActivity alloc] initWithDictionary:(NSDictionary *)d];
            [activities addObject:activity];
        }
        successBlock(activities, hasNextPage);
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        failureBlock();
      }];
}

// 搜索附近活动
+ (void)searchActivityNearBy:(NSString *)str
                  PageNumber:(NSUInteger)pageNumber
                     success:(void (^_Nullable)(NSMutableArray<WZActivity *> *, BOOL))
                                 successBlock
                     failure:(void (^_Nullable)(void))failureBlock {
  NSDictionary *param =
      @{ @"pName" : str,
         //@"pageNumber" : [NSNumber numberWithUnsignedInteger:pageNumber],
        // @"pageSize" : @10
         };
  AFHTTPSessionManager *manager = [self sharedManager];
  NSMutableArray<WZActivity *> *activities = [[NSMutableArray alloc] init];
  [manager POST:@"http://120.79.10.184:8080/product/search_byname"
      parameters:param
      progress:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nullable responseObject) {
          BOOL hasNextPage;
          NSDictionary *dict = ((NSDictionary *)responseObject)[@"data"];
          NSUInteger boolValue = [dict[@"hasNextPage"] unsignedIntegerValue];
          NSDictionary *activityDict = (NSDictionary *)(dict[@"list"]);
          if (boolValue != 0) {
              hasNextPage = YES;
          } else {
              hasNextPage = NO;
          }
        for (id d in activityDict) {
          WZActivity *activity =
              [[WZActivity alloc] initWithDictionary:(NSDictionary *)d];
          [activities addObject:activity];
        }
        successBlock(activities, hasNextPage);
      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        failureBlock();
      }];
}

// 根据类别查看活动
+ (void)browseActivityWith:(WZActivityCategory)category
                  Latitude:(double) latitude
                 Longitude:(double) longitude
                PageNumber:(NSUInteger)pageNumber
                   success:(void (^)(NSMutableArray<WZActivity *> *_Nonnull, BOOL))
                               successBlock
                   failure:(void (^)(void))failureBlock {
    NSDictionary *param =
    @{ @"pCate" : [NSNumber numberWithUnsignedInteger:category],
       @"pageNumber" : [NSNumber numberWithUnsignedInteger:pageNumber],
       @"pageSize" : @10 };
    AFHTTPSessionManager *manager = [self sharedManager];
    NSMutableArray<WZActivity *> *activities = [[NSMutableArray alloc] init];
    [manager POST:@"http://120.79.10.184:8080/product/search_byname"
       parameters:param
         progress:nil
          success:^(NSURLSessionDataTask *_Nonnull task,
                    id _Nullable responseObject) {
              BOOL hasNextPage;
              NSDictionary *dict = ((NSDictionary *)responseObject)[@"data"];
              NSUInteger boolValue = [dict[@"hasNextPage"] unsignedIntegerValue];
              NSDictionary *activityDict = (NSDictionary *)(dict[@"list"]);
              if (boolValue != 0) {
                  hasNextPage = YES;
              } else {
                  hasNextPage = NO;
              }
              for (id d in activityDict) {
                  WZActivity *activity =
                  [[WZActivity alloc] initWithDictionary:(NSDictionary *)d];
                  [activities addObject:activity];
              }
              successBlock(activities, hasNextPage);
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
              failureBlock();
          }];
}

@end
