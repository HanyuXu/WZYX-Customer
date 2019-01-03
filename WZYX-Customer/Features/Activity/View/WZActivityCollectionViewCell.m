//
//  WZActivityCollectionViewCell.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/13.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#define kWZActivityCollectionViewCellTopImageSize CGSizeMake(30,30)
#define kWZActivityCollectionViewCellBottomLabelSize CGSizeMake(30,10)
#define kWZActivityCollectionViewCellTopImageEdgeInsets UIEdgeInsetsMake(5,5,20,5)

#import "WZActivityCollectionViewCell.h"
#import <Masonry.h>

@implementation WZActivityCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview: self.topImage];
        [self.contentView addSubview:self.bottomLabel];
    }
    return self;
}

- (void) layoutSubviews {
    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(kWZActivityCollectionViewCellTopImageSize);
        make.top.left.right.equalTo(self.contentView).insets(kWZActivityCollectionViewCellTopImageEdgeInsets);
        make.centerX.equalTo(self.contentView);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(kWZActivityCollectionViewCellBottomLabelSize);
        //make.left.right.equalTo(self.contentView).insets(kWZActivityCollectionViewCellTopImageEdgeInsets);
//       make.top.equalTo(self.contentView).offset(45);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.centerX.equalTo(self.contentView);
    }];
}

#pragma mark - lazy load

- (UIImageView *) topImage {
    if (!_topImage) {
        _topImage = [[UIImageView alloc] init];
        _topImage.image = [UIImage imageNamed:@"Setting"];
    }
    return _topImage;
}

- (UILabel *) bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.text = @"测试";
    }
    //_bottomLabel.backgroundColor = [UIColor yellowColor];
    return _bottomLabel;
}

@end
