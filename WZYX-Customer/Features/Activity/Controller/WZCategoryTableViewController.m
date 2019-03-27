//
//  WZCategoryTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/27.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZCategoryTableViewController.h"
#import "WZactivityTableViewCell.h"
#import "WZActivityDetailTableViewController.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import <Masonry.h>

@interface WZCategoryTableViewController ()
@property(nonatomic, strong) MBProgressHUD *progressHUD;
@property(nonatomic, assign) NSUInteger pageNumber;
@property(nonatomic, assign) BOOL hasMoreData;
@property(nonatomic, strong) UILabel *promptLabel;
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
    [footer setTitle:@"无更多活动" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    [self.view addSubview:self.progressHUD];
    
    [self.progressHUD hideAnimated:YES];
    //[self.progressHUD showAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (fabs(self.longitude) <= 1e-5 && fabs(self.latitude) <= 1e-5){
        self.promptLabel.text = @"无法获取定位";
        [self layoutPromptLabel];
        return 0;
    }
    if (self.activities.count == 0) {
        self.promptLabel.text = @"附近暂无此类活动";
        [self layoutPromptLabel];
        return 0;
    }
    [self.promptLabel removeFromSuperview];
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WZActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected");
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    WZActivityDetailTableViewController *vc = [[WZActivityDetailTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - layout
- (void)layoutPromptLabel {
    [self.view addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
    }];
}
#pragma mark - load data
- (void)loadData {
    [self.progressHUD showAnimated:YES];
    [WZActivityManager browseActivityWith:self.category
                               PageNumber:self.pageNumber
                                  success:^(NSMutableArray<WZActivity *> * _Nonnull array, BOOL hasNextPage) {
        self.activities = array;
        self.hasMoreData = hasNextPage;
        if (!hasNextPage) {
                [self.tableView.mj_footer
                 endRefreshingWithNoMoreData];
        }
        [self.progressHUD hideAnimated:YES];
    } failure:^{
        [self.progressHUD hideAnimated: YES];
    }];
}
- (void)loadMoreData {
    if (!self.hasMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
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

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.textColor = [UIColor lightGrayColor];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLabel;
}
@end
