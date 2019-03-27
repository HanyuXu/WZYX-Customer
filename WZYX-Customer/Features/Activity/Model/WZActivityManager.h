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
typedef NS_ENUM(NSUInteger, WZActivitySortType) {
    WZActivitySortTypeDefault = 0,
    WZActivitySortTypeByHeat,
    WZActivitySortTypeByDate
};
typedef NS_ENUM(NSUInteger, WZActivityCategory) {
    WZActivityCategoryAll = 0,
    WZActivityCategoryBook,
    WZActivityCategoryComic,
    WZActivityCategoryMusic,
    WZActivityCategorySports
};

@interface WZActivityManager : NSObject

// 根据定位获取附近活动
+ (void)downLoadActivityListWithLatitude:(double) latitude
                               Longitude:(double) longitude
                                Category:(NSUInteger) category
                                SortType:(WZActivitySortType) sortType
                                 success:(void (^_Nullable)(NSMutableArray<WZActivity*>* activities, BOOL hasNextPage)) successBlock
                                 faliure:(void (^_Nullable)(void)) failureBlock;

// 搜索附近活动
+ (void)searchActivityNearBy:(NSString *)str
                  PageNumber:(NSUInteger)pageNumber
                     success:(void (^_Nullable)(NSMutableArray<WZActivity *> *, BOOL))
                                 successBlock
                     failure:(void (^_Nullable)(void))failureBlock;
// 根据类别查看活动
+ (void)browseActivityWith:(WZActivityCategory)category
                PageNumber:(NSUInteger)pageNumber
                   success:(void (^)(NSMutableArray<WZActivity *> *_Nonnull, BOOL))
                               successBlock
                   failure:(void (^)(void))failureBlock;
@end

    NS_ASSUME_NONNULL_END
