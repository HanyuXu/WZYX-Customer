//
//  WZActivityDetailTableViewController.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/19.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WZActivity;

@interface WZActivityDetailTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) WZActivity *activity;

@end

NS_ASSUME_NONNULL_END
