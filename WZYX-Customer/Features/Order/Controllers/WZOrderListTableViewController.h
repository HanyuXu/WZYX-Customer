//
//  WZOrderListTableViewController.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/30.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface WZOrderListTableViewController : UITableViewController

@property (assign, nonatomic) WZOrderState orderState;

- (instancetype)initWithStyle:(UITableViewStyle)style orderState:(WZOrderState)orderState;

- (void)loadOrderListData;
- (void)wipeOrderListData;

@end

NS_ASSUME_NONNULL_END
