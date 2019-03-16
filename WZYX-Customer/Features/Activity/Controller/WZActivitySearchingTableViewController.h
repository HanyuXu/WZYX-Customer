//
//  WZActivitySearchingTableViewController.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/25.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZActivitySearchingTableViewController : UIViewController

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *noResultLabel;
@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
