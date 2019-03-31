//
//  WZActivityCategoryTableViewCell.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/13.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZActivityCategoryTableViewCell.h"

#import <Masonry.h>

#define kWZActivityCategoryTableViewCellInsets UIEdgeInsetsMake(5, 5, 5, 5)

@interface WZActivityCategoryTableViewCell ()

@property(strong, nonatomic) UICollectionViewFlowLayout *layout;

@end

@implementation WZActivityCategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.categoryCollectionView];
    }
    [self bringSubviewToFront:self.contentView];
    return self;
}

- (void)layoutSubviews {
    [self.categoryCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(kWZActivityCategoryTableViewCellInsets);
    }];
}

#pragma mark - LazyLoad

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize =CGSizeMake(55, 70);
    }
    return _layout;
}

- (UICollectionView *)categoryCollectionView {
    if (!_categoryCollectionView) {
        _categoryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width,self.contentView.bounds.size.height) collectionViewLayout:self.layout];
    }
    _categoryCollectionView.backgroundColor = [UIColor clearColor];
    return _categoryCollectionView;
}

@end
