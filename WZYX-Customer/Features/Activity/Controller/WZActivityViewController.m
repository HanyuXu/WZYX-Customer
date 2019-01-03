//
//  WZActivityViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/6.
//  Copyright © 2018年 WZYX. All rights reserved.
//
#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "WZActivityViewController.h"
#import "WZActivityBaseTableView.h"
#import "WZActivitySearchBarCell.h"
#import "WZActivityCollectionViewCell.h"
#import "WZActivityCategoryTableViewCell.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import <SVPullToRefresh.h>
#import "WZActivityDetailTableViewController.h"

@interface WZActivityViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,FSSegmentTitleViewDelegate,FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property(strong, nonatomic) WZActivityCategoryTableViewCell *categoryCell;
@property(strong, nonatomic) FSSegmentTitleView *titleView;
@property (nonatomic, assign) BOOL canScroll;
@end

@implementation WZActivityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.categoryCell.categoryCollectionView registerClass:[WZActivityCollectionViewCell class] forCellWithReuseIdentifier:@"CategoryCollectionViewCell"];
    self.baseTableView.estimatedRowHeight = 44;
    self.baseTableView.rowHeight = UITableViewAutomaticDimension;
}


#pragma mark - tableview delegate
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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//location
            UITableViewCell *cell = [self.baseTableView dequeueReusableCellWithIdentifier:@"locationCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locationCell"];
            }
            cell.imageView.image = [UIImage imageNamed:@"Setting"];
            cell.textLabel.text = @"当前定位";
            return cell;
        } else if (indexPath.row==1) {//searchBar
            WZActivitySearchBarCell *cell = [self.baseTableView dequeueReusableCellWithIdentifier:@"searchBarCell"];
            if (!cell) {
                cell = [[WZActivitySearchBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchBarCell"];
            }
            return cell;
        }
    } else if (indexPath.section == 1) {//categotyCollectionView
        return self.categoryCell;
    } else if(indexPath.section == 2) { //bottom contentView;
//        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//        if (!_contentCell) {
//            _contentCell = [[WZActivityBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//            NSArray *titles = @[@"综合排序",@"距离最近",@"评价最高",@"筛选"];
//            NSMutableArray *contentVCs = [NSMutableArray array];
//            for (NSString *title in titles) {
//                WZActivityScrollContentViewController *vc = [[WZActivityScrollContentViewController alloc]init];
//                vc.title = title;
//                vc.str = title;
//                [contentVCs addObject:vc];
//            }
//            _contentCell.viewControllers = contentVCs;
//            _contentCell.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-50) childVCs:contentVCs parentVC:self delegate:self];
//            [_contentCell.contentView addSubview:_contentCell.pageContentView];
//        }
//        return _contentCell;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"测试数据";
        return cell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 100;
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==2 ){
        self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50) titles:@[@"综合排序",@"距离最近",@"评价最高",@"筛选"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
        self.titleView.backgroundColor = [UIColor whiteColor];
        return self.titleView;
    }
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 50;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.baseTableView deselectRowAtIndexPath:indexPath animated:YES];
    WZActivityDetailTableViewController *detailTVC = [[WZActivityDetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:detailTVC animated:YES];
    
}

//#pragma mark - scrollview delagate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat bottomCellOffset = [self.baseTableView rectForSection:2].origin.y-50;
//    if (scrollView.contentOffset.y >= bottomCellOffset) {
//        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
//        if (self.canScroll) {
//            self.canScroll = NO;
//            self.contentCell.cellCanScroll = YES;
//        }
//    }else{
//        if (!self.canScroll) {//子视图没到顶部
//            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
//        }
//    }
//    self.baseTableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
//}

#pragma mark - collectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WZActivityCollectionViewCell *cell = [self.categoryCell.categoryCollectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (self.view.bounds.size.width-55*4-20)/4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WZActivityCollectionViewCell *cell = (WZActivityCollectionViewCell *)[self.categoryCell.categoryCollectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"%@",cell.bottomLabel.text);
}


#pragma mark - lazy load
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
    //_categoryCell.contentView.backgroundColor = [UIColor redColor];
    
    return _categoryCell;
}

@end
