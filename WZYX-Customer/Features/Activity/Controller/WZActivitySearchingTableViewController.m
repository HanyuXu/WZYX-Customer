//
//  WZActivitySearchingTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/25.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZActivitySearchingTableViewController.h"
#import "WZActivity.h"
#import "WZActivityManager.h"
#import "WZActivityTableViewCell.h"
#import "WZDateStringConverter.h"
#import <Masonry.h>
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface WZActivitySearchingTableViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(nonatomic, strong) NSMutableArray<WZActivity*> *result;
@property(nonatomic, assign) NSUInteger pageNumber;
@property(nonatomic, assign) BOOL hasMoreData;
@property(nonatomic, strong) MBProgressHUD *progressHUD;
@property(nonatomic, strong) NSString *searchString;
@end

@implementation WZActivitySearchingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchBar);
        make.left.equalTo(self.view).offset(5);
    }];
    //弹出键盘
    self.view.backgroundColor = [UIColor whiteColor];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - SearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *str = searchBar.text;
    [searchBar resignFirstResponder];
    if (str) {
        [self.progressHUD showAnimated:YES];
        self.searchString = str;
        [self loadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self.noResultLabel removeFromSuperview];
        [self.tableView removeFromSuperview];
    }
}

#pragma mark - BackButton

- (void)backToMain {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (UIImage*)GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height {
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Layout

- (void)layoutNoResultLabel {
    [self.view addSubview:self.noResultLabel];
    [self.noResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.result.count == 0) {
        [self layoutNoResultLabel];
        return 0;
    }else {
        [self.noResultLabel removeFromSuperview];
        return self.result.count;
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WZActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.activityNameLabel.text = self.result[indexPath.row].pName;
    if (self.result[indexPath.row].pLocation){
        cell.activityLocationLabel.text = self.result[indexPath.row].pLocation;
    }
    NSLog(@"%@",self.result[indexPath.row].pStarttime);
    NSString *startTime = [WZDateStringConverter stringFromDateString:self.result[indexPath.row].pStarttime];
    NSString *endTime = [WZDateStringConverter stringFromDateString:self.result[indexPath.row].pEndtime];
    cell.activityDateLabel.text = [NSString stringWithFormat:@"%@-%@", startTime, endTime];
    NSString *price = [NSString stringWithFormat:@"￥%.2f", self.result[indexPath.row].pPrice];
    cell.activityPirceLabel.text = price;
    NSURL *url = [NSURL URLWithString:self.result[indexPath.row].pImage];
    [cell.activityImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"book"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - load data
- (void)loadData {
    [WZActivityManager
     searchActivityNearBy:self.searchString PageNumber:self.pageNumber
     success:^(NSMutableArray<WZActivity *> *_Nonnull activities,
               BOOL hasNextPage) {
         self.pageNumber += 1;
         self.hasMoreData = hasNextPage;
         self.result = activities;
         [self.progressHUD hideAnimated:YES];
         [self.view addSubview:self.tableView];
         [self.tableView reloadData];
     }failure:^{
         
     }];
}

- (void)loadMoreData {
    if (self.result.count == 0) {
        return;
    }
    if (!_hasMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [WZActivityManager
     searchActivityNearBy:self.searchString PageNumber:self.pageNumber
     success:^(NSMutableArray<WZActivity *> *_Nonnull activities,
               BOOL hasNextPage) {
         self.pageNumber += 1;
         self.hasMoreData = hasNextPage;
         for (WZActivity *activity in activities) {
             [self.result addObject:activity];
         }
         [self.tableView reloadData];
     }failure:^{
         
     }];
}

#pragma mark - LazyLoad

- (UISearchBar *)searchBar {
    if (!_searchBar) {
         CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(30, statusRect.size.height, self.view.bounds.size.width-35, 44)];
        _searchBar.placeholder = @"请输入活动名";
        _searchBar.delegate = self;
        UITextField *searchField=[_searchBar valueForKey:@"searchField"];
        searchField.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:0.3];
        [_searchBar setBackgroundImage:[UIImage new]];
        [_searchBar setTranslucent:YES];
        _searchBar.keyboardType = UIKeyboardTypeDefault;
        for (UIView *view in _searchBar.subviews) {
            if ([view isKindOfClass:UITextField.class]) {
                UITextField *textField = (UITextField *)view;
                textField.delegate = self;
            }
        }
    }
    return _searchBar;
}

- (UIButton *)backButton {
    if (!_backButton) {
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        CGRect frame = CGRectMake(0, statusRect.size.height+10, 25, 25);
        _backButton = [[UIButton alloc] initWithFrame:frame];
        //_backButton.backgroundColor = [UIColor redColor];
        UIImage *image = [UIImage imageNamed:@"back"];
        [_backButton setBackgroundImage:image forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)noResultLabel {
    if (!_noResultLabel) {
        _noResultLabel = [[UILabel alloc] init];
        _noResultLabel.text = @"未搜索到相关活动";
        _noResultLabel.textColor = [UIColor lightGrayColor];
    }
    return _noResultLabel;
}

- (NSMutableArray<WZActivity*> *)result {
    if( !_result ){
        _result = [[NSMutableArray alloc] init];
    }
    return _result;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.size.height + 20, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height - 20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
        [footer setTitle:@"无更多活动" forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = footer;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - lazyload
- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
        _progressHUD.label.text = @"加载中";
        _progressHUD.alpha = 0.5;
        _progressHUD.removeFromSuperViewOnHide = NO;
        [self.view addSubview:_progressHUD];
    }
    return _progressHUD;
}
@end
