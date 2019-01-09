//
//  WZOrderTitleTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/7.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZOrderTitleTableViewCell.h"

#import "Masonry.h"

#define kWZOrderTitleTableViewCellEdgeInsets                 UIEdgeInsetsMake(10, 15, 10, 15)
#define kWZOrderTitleTableViewCellCommodityImageViewSize     CGSizeMake(60, 60)

@implementation WZOrderTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.eventAvatarImageView];
        [self.contentView addSubview:self.eventTitleLabel];
        [self.contentView addSubview:self.eventSeasonLabel];
        [self.eventAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).insets(kWZOrderTitleTableViewCellEdgeInsets);
            make.size.mas_equalTo(kWZOrderTitleTableViewCellCommodityImageViewSize).priority(800);
        }];
        [self.eventTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.contentView).insets(kWZOrderTitleTableViewCellEdgeInsets);
            make.left.equalTo(self.eventAvatarImageView.mas_right).offset(kWZOrderTitleTableViewCellEdgeInsets.left);
        }];
        [self.eventSeasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.eventTitleLabel.mas_bottom);
            make.left.equalTo(self.eventTitleLabel);
            make.bottom.right.equalTo(self.contentView).insets(kWZOrderTitleTableViewCellEdgeInsets);
        }];
    }
    return self;
}

#pragma mark - LazyLoad

- (UIImageView *)eventAvatarImageView {
    if (!_eventAvatarImageView) {
        _eventAvatarImageView = [[UIImageView alloc] init];
    }
    return _eventAvatarImageView;
}

- (UILabel *)eventTitleLabel {
    if (!_eventTitleLabel) {
        _eventTitleLabel = [[UILabel alloc] init];
        _eventTitleLabel.numberOfLines = 2;
        _eventTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _eventTitleLabel;
}

- (UILabel *)eventSeasonLabel {
    if (!_eventSeasonLabel) {
        _eventSeasonLabel = [[UILabel alloc] init];
        _eventSeasonLabel.numberOfLines = 3;
        _eventSeasonLabel.font = [UIFont systemFontOfSize:10];
        _eventSeasonLabel.textColor = [UIColor grayColor];
    }
    return _eventSeasonLabel;
}

@end
