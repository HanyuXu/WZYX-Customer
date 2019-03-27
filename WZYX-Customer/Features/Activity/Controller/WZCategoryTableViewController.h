//
//  WZCategoryTableViewController.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/27.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZActivityManager.h"
NS_ASSUME_NONNULL_BEGIN

@class WZActivity;

@interface WZCategoryTableViewController : UITableViewController
@property(nonatomic, assign) WZActivityCategory category;
@property(nonatomic, assign) NSArray<WZActivity *> *activities;
@property(nonatomic, assign) CGFloat latitude;
@property(nonatomic, assign) CGFloat longitude;
@end

NS_ASSUME_NONNULL_END
