//
//  WZActivityCollectionViewCell.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/13.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZActivityCollectionViewCell.h"
#import <Masonry.h>

#define kWZActivityCollectionViewCellTopImageSize       CGSizeMake(30, 30)
#define kWZActivityCollectionViewCellBottomLabelSize CGSizeMake(30, 10)
#define kWZActivityCollectionViewCellTopImageEdgeInsets UIEdgeInsetsMake(5, 5, 20, 5)

@implementation WZActivityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview: self.topImage];
        [self.contentView addSubview:self.bottomLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView).insets(kWZActivityCollectionViewCellTopImageEdgeInsets);
        make.size.mas_equalTo(CGSizeMake(36, 36)).priority(800);
        make.centerX.equalTo(self.contentView);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-5);
        make.centerX.equalTo(self.contentView);
    }];
}

#pragma mark - LazyLoad

- (UIImageView *)topImage {
    if (!_topImage) {
        _topImage = [[UIImageView alloc] init];
    }
    return _topImage;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = [UIFont systemFontOfSize:14];
    }
    //_bottomLabel.backgroundColor = [UIColor yellowColor];
    return _bottomLabel;
}

@end
