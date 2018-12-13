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

@interface WZActivityViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property(strong, nonatomic) WZActivityCategoryTableViewCell *categoryCell;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else if(section == 1) {
        return 1;
    }
    return 0;
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
    }
    return nil;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(section == 0) {
//        return 20.0f;
//    }
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 100;
    }
    return UITableViewAutomaticDimension;
}


#pragma mark - scrollview delagate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

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
