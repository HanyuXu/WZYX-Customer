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
#import "WZActivity.h"
#import "WZDateStringConverter.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface WZCategoryTableViewController ()
@property(nonatomic, strong) MBProgressHUD *progressHUD;
@property(nonatomic, assign) NSUInteger currentPageNumber;
@property(nonatomic, assign) BOOL hasMoreData;
@property(nonatomic, strong) UILabel *promptLabel;
@end

@implementation WZCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPageNumber = 1;
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
    [self loadData];
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
    if (self.activityList.count == 0) {
        self.promptLabel.text = @"附近暂无此类活动";
        [self layoutPromptLabel];
        return 0;
    }
    [self.promptLabel removeFromSuperview];
    return self.activityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WZActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.activityNameLabel.text = self.activityList[indexPath.row].pName;
    if (self.activityList[indexPath.row].pLocation){
        cell.activityLocationLabel.text = self.activityList[indexPath.row].pLocation;
    }
    NSString *startTime = [WZDateStringConverter stringFromDateString:self.activityList[indexPath.row].pStarttime];
    NSString *endTime = [WZDateStringConverter stringFromDateString:self.activityList[indexPath.row].pEndtime];
    cell.activityDateLabel.text = [NSString stringWithFormat:@"%@-%@", startTime, endTime];
    NSString *price = [NSString stringWithFormat:@"￥%.2f", self.activityList[indexPath.row].pPrice];
    cell.activityPirceLabel.text = price;
    NSURL *url = [NSURL URLWithString:self.activityList[indexPath.row].pImage];
    [cell.activityImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"book"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [WZActivityManager
     downLoadActivityListWithLatitude:self.latitude
     Longitude:self.longitude
     Category:self.category
     SortType:0
     PageNumber:self.currentPageNumber
     success:^(NSMutableArray<WZActivity *> * _Nonnull activities, BOOL hasNextPage) {
         [self.activityList removeAllObjects];
         self.activityList = activities;
         
         self.hasMoreData = hasNextPage;
         self.currentPageNumber += 1;
         [self.tableView reloadData];
         [self.progressHUD hideAnimated:YES];
     } faliure:^{
         [self.progressHUD hideAnimated:YES];
     }];
}
- (void)loadMoreData {
    if (self.activityList.count == 0) {
        return;
    }
    if (!self.hasMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [WZActivityManager
     downLoadActivityListWithLatitude:self.latitude Longitude:self.longitude Category:self.category SortType:0 PageNumber: self.currentPageNumber
     success:^(NSMutableArray<WZActivity *> * _Nonnull activities, BOOL hasNextPage) {
         for (WZActivity *activity in activities) {
             [self.activityList addObject:activity];
         }
         self.currentPageNumber += 1;
         self.hasMoreData = hasNextPage;
         [self.tableView reloadData];
     } faliure:^{
         
     }];
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
