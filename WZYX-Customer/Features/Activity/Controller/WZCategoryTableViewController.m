//
//  WZCategoryTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/27.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZCategoryTableViewController.h"
#import "WZactivityTableViewCell.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>

@interface WZCategoryTableViewController ()
@property(nonatomic, strong) MBProgressHUD *progressHUD;
@end

@implementation WZCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // MJRefresh
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
    self.tableView.mj_footer = footer;
    [self.tableView addSubview:self.progressHUD];
    [self.progressHUD showAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WZActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - load data
- (void)loadMoreData {
    [self.progressHUD showAnimated:YES];
}
#pragma mark - lazy load
- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
        _progressHUD.label.text = @"加载中";
        _progressHUD.alpha = 0.5;
        _progressHUD.removeFromSuperViewOnHide = NO;
    }
    return _progressHUD;
}

@end
