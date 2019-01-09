//
//  WZCommentTableViewController.h
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/7.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WZOrder;
@class WZCommentTableViewController;

@protocol WZCommentTableViewControllerDelegate <NSObject>

- (void)commentTableViewController:(WZCommentTableViewController *)commentVC didFinishCommentSuccess:(BOOL)success userInfo:(NSString * _Nullable)userInfo;

@end

@interface WZCommentTableViewController : UITableViewController

@property (strong, nonatomic) WZOrder *order;
@property (weak, nonatomic) id<WZCommentTableViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
