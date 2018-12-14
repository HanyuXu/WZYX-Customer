//
//  WZOrderPriceTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/10.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZOrderPriceTableViewCell.h"

#import "Masonry.h"

#define kWZOrderPriceTableViewCellEdgeInsets           UIEdgeInsetsMake(10, 15, 10, 15)
#define kWZOrderPriceTableViewCellFontSize             14
#define kWZOrderPriceTableViewCellFontSizeLarge        16

@interface WZOrderPriceTableViewCell ()

@property (strong, nonatomic) UILabel *totalPriceTitleLabel;
@property (strong, nonatomic) UILabel *discountTitleLabel;
@property (strong, nonatomic) UILabel *actualPaymentTitleLabel;

@end

@implementation WZOrderPriceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.totalPriceTitleLabel];
        [self.contentView addSubview:self.discountTitleLabel];
        [self.contentView addSubview:self.actualPaymentTitleLabel];
        [self.contentView addSubview:self.totalPriceLabel];
        [self.contentView addSubview:self.discountLabel];
        [self.contentView addSubview:self.actualPaymentLabel];
        
        [self.totalPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).insets(kWZOrderPriceTableViewCellEdgeInsets);
        }];
        [self.discountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.totalPriceTitleLabel.mas_bottom).offset(kWZOrderPriceTableViewCellEdgeInsets.top);
            make.left.equalTo(self.contentView).offset(kWZOrderPriceTableViewCellEdgeInsets.left);
        }];
        [self.actualPaymentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.discountTitleLabel.mas_bottom).offset(kWZOrderPriceTableViewCellEdgeInsets.top);
            make.left.bottom.equalTo(self.contentView).insets(kWZOrderPriceTableViewCellEdgeInsets);
        }];
        [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).insets(kWZOrderPriceTableViewCellEdgeInsets);
            make.centerY.equalTo(self.totalPriceTitleLabel);
        }];
        [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).insets(kWZOrderPriceTableViewCellEdgeInsets);
            make.centerY.equalTo(self.discountTitleLabel);
        }];
        [self.actualPaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).insets(kWZOrderPriceTableViewCellEdgeInsets);
            make.centerY.equalTo(self.actualPaymentTitleLabel);
        }];
    }
    return self;
}

#pragma mark - LazyLoad

- (UILabel *)totalPriceTitleLabel {
    if (!_totalPriceTitleLabel) {
        _totalPriceTitleLabel = [[UILabel alloc] init];
        _totalPriceTitleLabel.text = @"订单总价：";
        _totalPriceTitleLabel.font = [UIFont systemFontOfSize:kWZOrderPriceTableViewCellFontSize];
    }
    return _totalPriceTitleLabel;
}

- (UILabel *)discountTitleLabel {
    if (!_discountTitleLabel) {
        _discountTitleLabel = [[UILabel alloc] init];
        _discountTitleLabel.text = @"优惠：";
        _discountTitleLabel.font = [UIFont systemFontOfSize:kWZOrderPriceTableViewCellFontSize];
    }
    return _discountTitleLabel;
}

- (UILabel *)actualPaymentTitleLabel {
    if (!_actualPaymentTitleLabel) {
        _actualPaymentTitleLabel = [[UILabel alloc] init];
        _actualPaymentTitleLabel.text = @"实付款：";
        _actualPaymentTitleLabel.font = [UIFont systemFontOfSize:kWZOrderPriceTableViewCellFontSizeLarge];
    }
    return _actualPaymentTitleLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.font = [UIFont systemFontOfSize:kWZOrderPriceTableViewCellFontSize];
    }
    return _totalPriceLabel;
}

- (UILabel *)discountLabel {
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.font = [UIFont systemFontOfSize:kWZOrderPriceTableViewCellFontSize];
    }
    return _discountLabel;
}

- (UILabel *)actualPaymentLabel {
    if (!_actualPaymentLabel) {
        _actualPaymentLabel = [[UILabel alloc] init];
        _actualPaymentLabel.font = [UIFont systemFontOfSize:kWZOrderPriceTableViewCellFontSizeLarge];
        _actualPaymentLabel.textColor = [UIColor redColor];
    }
    return _actualPaymentLabel;
}

@end
