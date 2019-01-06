//
//  WZPayTableViewController.h
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/4.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WZOrder;
@class WZPayTableViewController;

@protocol WZPayTableViewControllerDelegate <NSObject>

- (void)payTableViewController:(WZPayTableViewController *)payVC didFinishPaySuccess:(BOOL)success userInfo:(NSString * _Nullable)userInfo;

@end

@interface WZPayTableViewController : UITableViewController

@property (strong, nonatomic) WZOrder *order;
@property (weak, nonatomic) id<WZPayTableViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
