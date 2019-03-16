//
//  WZActivityViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/6.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZActivityViewController.h"
#import "WZActivityBaseTableView.h"
#import "WZActivitySearchBarCell.h"
#import "WZActivityCollectionViewCell.h"
#import "WZActivityCategoryTableViewCell.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import "WZActivityDetailTableViewController.h"
#import "WZActivityTableViewCell.h"
#import "WZActivityManager.h"
#import "WZActivitySearchingTableViewController.h"
#import "WZCategoryTableViewController.h"
#import "JFLocation.h"
#import "JFAreaDataManager.h"
#import "JFCityViewController.h"
#import <MJRefresh.h>
#import <Masonry.h>

#define KSCREEN_WIDTH               [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT              [UIScreen mainScreen].bounds.size.height
#define KCURRENTCITYINFODEFAULTS    [NSUserDefaults standardUserDefaults]

@interface WZActivityViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,FSSegmentTitleViewDelegate,FSPageContentViewDelegate,FSSegmentTitleViewDelegate, UISearchBarDelegate,JFLocationDelegate, JFCityViewControllerDelegate>

@property (strong, nonatomic) WZActivityCategoryTableViewCell *categoryCell;
@property (strong, nonatomic) FSSegmentTitleView *titleView;
@property (nonatomic, assign) BOOL canScroll;
/** 城市定位管理器*/
@property (nonatomic, strong) JFLocation *locationManager;
/** 城市数据管理器*/
@property (nonatomic, strong) JFAreaDataManager *manager;
@property (nonatomic, strong) UITableViewCell *LocationCell;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSUInteger currentPageNumber;
@property (nonatomic, assign) NSUInteger sortType;

@end

@implementation WZActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.categoryCell.categoryCollectionView registerClass:[WZActivityCollectionViewCell class] forCellWithReuseIdentifier:@"CategoryCollectionViewCell"];
    self.baseTableView.estimatedRowHeight = 44;
    self.baseTableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationItem.title = @"活动";
    self.activityList = self.activitySortedByHeatRate;
    //location
    self.locationManager = [[JFLocation alloc] init];
    _locationManager.delegate = self;
    //MJRefresh
}

#pragma mark - FSPageContnetViewDelagate

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    if (endIndex == 0 || endIndex == 2) {
        self.sortType = 1;
    }
    else {
        self.sortType = 0;
    }
    if (self.currentCity) {
        [self loadData];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else if(section == 1) {
        return 1;
    }
    if (self.count == 0) {
        [self layoutPromptLabel];
    }
    if (self.activityList.count == 0) {
        [self layoutPromptLabel];
        self.promptLabel.text = @"附近暂无活动";
    } else {
        [self.promptLabel removeFromSuperview];
    }
    return self.activityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//location
            UITableViewCell *cell = [self.baseTableView dequeueReusableCellWithIdentifier:@"locationCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locationCell"];
                cell.imageView.image = [UIImage imageNamed:@"location"];
                cell.textLabel.text = @"选择城市";
            }
            return cell;
        } else if (indexPath.row==1) {//searchBar
            WZActivitySearchBarCell *cell = [self.baseTableView dequeueReusableCellWithIdentifier:@"searchBarCell"];
            if (!cell) {
                cell = [[WZActivitySearchBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchBarCell"];
                cell.searchBar.delegate = self;
            }
            return cell;
        }
    } else if (indexPath.section == 1) {//categotyCollectionView
        return self.categoryCell;
    } else if (indexPath.section == 2) {
        WZActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[WZActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if(indexPath.row == 1){
            return 44;
        }
    }
    if (indexPath.section == 1) {
        return 85;
    }
    if(indexPath.section == 2){
        return 120;
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==2 ){
        return self.titleView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 50;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.baseTableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
            cityViewController.delegate = self;
            cityViewController.title = @"城市";
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
            [self presentViewController:navigationController animated:YES completion:nil];
            return;
        } else{
            // do nothing
            return;
        }
    }
    WZActivityDetailTableViewController *detailTVC = [[WZActivityDetailTableViewController alloc] init];
    detailTVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailTVC animated:YES];
}

#pragma mark - MJRefresh

- (void)initTableViewRefreshFooter {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
    self.baseTableView.mj_footer = footer;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WZActivityCollectionViewCell *cell = [self.categoryCell.categoryCollectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.topImage.image = [UIImage imageNamed:@"book"];
        cell.bottomLabel.text = @"书展";
    } else if (indexPath.row == 1) {
        cell.topImage.image = [UIImage imageNamed:@"cartoon"];
        cell.bottomLabel.text = @"漫展";
    } else if (indexPath.row == 2) {
        cell.topImage.image = [UIImage imageNamed:@"music"];
        cell.bottomLabel.text = @"音乐";
    } else {
        cell.topImage.image = [UIImage imageNamed:@"sports"];
        cell.bottomLabel.text = @"运动";
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (self.view.bounds.size.width - 55 * 4 - 20) / 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WZActivityCollectionViewCell *cell = (WZActivityCollectionViewCell *)[self.categoryCell.categoryCollectionView cellForItemAtIndexPath:indexPath];
    WZCategoryTableViewController *vc = [[WZCategoryTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.navigationItem.title = cell.bottomLabel.text;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    WZActivitySearchingTableViewController *vc = [[WZActivitySearchingTableViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [searchBar resignFirstResponder];
    return;
}

#pragma mark - DownloadDateFromInternet

- (void)loadData {
    [WZActivityManager downLoadActivityListWithSortType:self.sortType success:^(NSMutableArray<WZActivity *> * _Nonnull activities) {
        [self.activityList removeAllObjects];
        self.activityList = activities;
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
        [self.baseTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } faliure:^{
        NSLog(@"failure!");
    }];
}

- (void)loadMoreData {
    if (self.activityList.count == 0) {
        return;
    }
    WZActivity *activity = [[WZActivity alloc] init];
    for(int i = 0; i < 5; ++i) {
        [self.activityList addObject:activity];
    }
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
    //dispatch_time(DISPATCH_TIME_NOW, 3);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.baseTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.baseTableView.mj_footer endRefreshing];
    });
}

#pragma mark - JFLocationDelagate

- (void)cityName:(NSString *)name {
    NSLog(@"定位成功");
    self.currentCity = name;
    self.LocationCell.textLabel.text = name;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
    [self.baseTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.promptLabel removeFromSuperview];
    [self initTableViewRefreshFooter];
    // load data
    [self loadData];
}

//定位中...
- (void)locating {
    NSLog(@"定位中...");
    self.LocationCell.textLabel.text = @"定位中...";
    self.promptLabel.text = @"正在定位，您可以手动选择定位";
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    NSString *city = [locationDictionary valueForKey:@"City"];
    if (![self.LocationCell.textLabel.text isEqualToString:city]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您定位到%@，确定切换城市吗？",city] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.LocationCell.textLabel.text = city;
            [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"locationCity"];
            [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"currentCity"];
            [self.manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
                [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
            }];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    NSLog(@"%@",message);
}

//定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout

- (void)layoutPromptLabel{
    [self.baseTableView addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        CGRect rect = [self.baseTableView rectForSection:1];
        CGFloat height = self.view.bounds.size.height - rect.size.height;
        make.bottom.equalTo(self.view).offset(-height/2);
    }];
}

#pragma mark - LazyLoad

- (WZActivityBaseTableView *)baseTableView {
    if (!_baseTableView) {
        _baseTableView = [[WZActivityBaseTableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        _baseTableView.dataSource = self;
        _baseTableView.delegate = self;
        _baseTableView.backgroundColor = [UIColor whiteColor];
        //self.automaticallyAdjustsScrollViewInsets = YES;
    }
    return _baseTableView;
}

- (WZActivityCategoryTableViewCell *) categoryCell {
    if (!_categoryCell) {
        _categoryCell = [[WZActivityCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryCell"];
        _categoryCell.categoryCollectionView.dataSource = self;
        _categoryCell.categoryCollectionView.delegate = self;
    }
    return _categoryCell;
}

//- (NSMutableArray<WZActivity*> *)activityList {
//    if (!_activityList) {
//        _activityList = self.activitySortedByHeatRate; //默认为按热度排序
//    }
//    return _activityList;
//}

- (NSMutableArray<WZActivity*> *)activitySortedByHeatRate {
    if(!_activitySortedByHeatRate) {
        _activitySortedByHeatRate = [[NSMutableArray alloc] init];
    }
    return _activitySortedByHeatRate;
}

- (NSMutableArray<WZActivity*> *)activitySortedByDate {
    if(!_activitySortedByDate) {
        _activitySortedByDate = [[NSMutableArray alloc] init];
    }
    return _activitySortedByDate;
}

- (UITableViewCell *)LocationCell {
    if(!_LocationCell) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        _LocationCell = [self.baseTableView cellForRowAtIndexPath:path];
    }
    return _LocationCell;
}

- (JFAreaDataManager *)manager {
    if (!_manager) {
        _manager = [JFAreaDataManager shareInstance];
        [_manager areaSqliteDBData];
    }
    return _manager;
}

- (UILabel *)promptLabel {
    if(!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = @"无法获取附近活动";
        _promptLabel.textColor = [UIColor lightGrayColor];
        //_promptLabel.contentMode = UIViewContentModeScaleToFill;
    }
    return _promptLabel;
}

- (FSSegmentTitleView *)titleView {
    if( !_titleView) {
        _titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50) titles:@[@"综合排序",@"时间最近",@"热度最高"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}

@end
