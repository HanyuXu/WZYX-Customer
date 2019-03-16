//
//  WZActivityViewController.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/6.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZActivity.h"

NS_ASSUME_NONNULL_BEGIN

@class WZActivityBaseTableView;

@interface WZActivityViewController : UIViewController

@property (strong, nonatomic) WZActivityBaseTableView *baseTableView;
@property (strong, nonatomic) NSMutableArray<WZActivity*> *activityList;
@property (strong, nonatomic) NSMutableArray<WZActivity*> *activitySortedByHeatRate;
@property (strong, nonatomic) NSMutableArray<WZActivity*> *activitySortedByDate;

@end

NS_ASSUME_NONNULL_END
