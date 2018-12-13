//
//  WZOrderTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/30.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZOrderTableViewCell.h"

#import "Masonry.h"

#define kWZOrderTableViewCellEdgeInsets                 UIEdgeInsetsMake(10, 15, 10, 15)
#define kWZOrderTableViewCellCommodityImageViewSize     CGSizeMake(80, 80)
#define kWZOrderTableViewCellFontSize                   14
#define kWZOrderTableViewCellFontSizeSmall              12

@implementation WZOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.sponsorNameButton];
        [self.contentView addSubview:self.orderStateLabel];
        [self.contentView addSubview:self.eventAvatarImageView];
        [self.contentView addSubview:self.priceAndCountLabel];
        [self.contentView addSubview:self.eventTitleLabel];
        [self.contentView addSubview:self.eventSeasonLabel];
        [self.contentView addSubview:self.orderAmountLabel];
        
        [self.sponsorNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).insets(kWZOrderTableViewCellEdgeInsets);
            make.width.lessThanOrEqualTo(@250);
        }];
        [self.orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.sponsorNameButton);
            make.right.equalTo(self.contentView).insets(kWZOrderTableViewCellEdgeInsets);
        }];
        [self.eventAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sponsorNameButton.mas_bottom).offset(kWZOrderTableViewCellEdgeInsets.top);
            make.left.equalTo(self.contentView).insets(kWZOrderTableViewCellEdgeInsets);
            make.size.mas_equalTo(kWZOrderTableViewCellCommodityImageViewSize).priority(800);
        }];
        [self.priceAndCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.eventAvatarImageView);
            make.right.equalTo(self.contentView).insets(kWZOrderTableViewCellEdgeInsets);
        }];
        [self.eventTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.eventAvatarImageView);
            make.left.equalTo(self.eventAvatarImageView.mas_right).offset(kWZOrderTableViewCellEdgeInsets.left);
            make.right.equalTo(self.priceAndCountLabel.mas_left).offset(-kWZOrderTableViewCellEdgeInsets.right);
        }];
        [self.eventSeasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.eventTitleLabel.mas_bottom).offset(kWZOrderTableViewCellEdgeInsets.top);
            make.left.right.equalTo(self.eventTitleLabel);
        }];
        [self.orderAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.eventAvatarImageView.mas_bottom).offset(kWZOrderTableViewCellEdgeInsets.top);
            make.bottom.right.equalTo(self.contentView).insets(kWZOrderTableViewCellEdgeInsets);
        }];
    }
    return self;
}

#pragma mark - LazyLoad

- (UIButton *)sponsorNameButton {
    if (!_sponsorNameButton) {
        _sponsorNameButton = [[UIButton alloc] init];
        _sponsorNameButton.titleLabel.font = [UIFont systemFontOfSize:kWZOrderTableViewCellFontSize];
        [_sponsorNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _sponsorNameButton;
}

- (UILabel *)orderStateLabel {
    if (!_orderStateLabel) {
        _orderStateLabel = [[UILabel alloc] init];
        _orderStateLabel.font = [UIFont systemFontOfSize:kWZOrderTableViewCellFontSize];
        _orderStateLabel.textColor = [UIColor redColor];
    }
    return _orderStateLabel;
}

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
        _eventTitleLabel.font = [UIFont systemFontOfSize:kWZOrderTableViewCellFontSize];
    }
    return _eventTitleLabel;
}

- (UILabel *)priceAndCountLabel {
    if (!_priceAndCountLabel) {
        _priceAndCountLabel = [[UILabel alloc] init];
        _priceAndCountLabel.numberOfLines = 2;
        _priceAndCountLabel.font = [UIFont systemFontOfSize:kWZOrderTableViewCellFontSizeSmall];
        _priceAndCountLabel.textAlignment = NSTextAlignmentRight;
        [_priceAndCountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _priceAndCountLabel;
}

- (UILabel *)eventSeasonLabel {
    if (!_eventSeasonLabel) {
        _eventSeasonLabel = [[UILabel alloc] init];
        _eventSeasonLabel.numberOfLines = 2;
        _eventSeasonLabel.font = [UIFont systemFontOfSize:kWZOrderTableViewCellFontSizeSmall];
        _eventSeasonLabel.textColor = [UIColor grayColor];
    }
    return _eventSeasonLabel;
}

- (UILabel *)orderAmountLabel {
    if (!_orderAmountLabel) {
        _orderAmountLabel = [[UILabel alloc] init];
        _orderAmountLabel.numberOfLines = 3;
        _orderAmountLabel.font = [UIFont systemFontOfSize:kWZOrderTableViewCellFontSize];
    }
    return _orderAmountLabel;
}

@end
