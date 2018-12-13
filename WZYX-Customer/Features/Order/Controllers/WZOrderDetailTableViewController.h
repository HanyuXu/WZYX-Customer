//
//  WZOrderDetailTableViewController.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/10.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WZOrder;

@protocol WZOrderDetailTableViewControllerDelegate <NSObject>

- (void)orderStateDidUpdate;

@end

@interface WZOrderDetailTableViewController : UITableViewController

@property (strong, nonatomic) WZOrder *order;
@property (weak, nonatomic) id<WZOrderDetailTableViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
