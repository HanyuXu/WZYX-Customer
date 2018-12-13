//
//  WZOrderInfoTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/10.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZOrderInfoTableViewCell.h"

#import "Masonry.h"

#define kWZOrderInfoTableViewCellEdgeInsets           UIEdgeInsetsMake(10, 15, 10, 15)
#define kWZOrderInfoTableViewCellFontSize             14

@interface WZOrderInfoTableViewCell ()

@property (strong, nonatomic) UILabel *orderIdTitleLabel;
@property (strong, nonatomic) UILabel *orderTimeStampTitleLabel;
@property (strong, nonatomic) UILabel *paymentMethodTitleLabel;
@property (strong, nonatomic) UILabel *paymentTimeStampTitleLabel;

@end

@implementation WZOrderInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.orderIdTitleLabel];
        [self.contentView addSubview:self.orderTimeStampTitleLabel];
        [self.contentView addSubview:self.paymentMethodTitleLabel];
        [self.contentView addSubview:self.paymentTimeStampTitleLabel];
        
        [self.contentView addSubview:self.orderIdLabel];
        [self.contentView addSubview:self.orderTimeStampLabel];
        [self.contentView addSubview:self.paymentMethodLabel];
        [self.contentView addSubview:self.paymentTimeStampLabel];
        
        [self.orderIdTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).insets(kWZOrderInfoTableViewCellEdgeInsets);
        }];
        [self.orderTimeStampTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderIdTitleLabel.mas_bottom).offset(kWZOrderInfoTableViewCellEdgeInsets.top);
            make.left.equalTo(self.contentView).offset(kWZOrderInfoTableViewCellEdgeInsets.left);
        }];
        [self.paymentMethodTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderTimeStampTitleLabel.mas_bottom).offset(kWZOrderInfoTableViewCellEdgeInsets.top);
            make.left.equalTo(self.contentView).offset(kWZOrderInfoTableViewCellEdgeInsets.left);
        }];
        [self.paymentTimeStampTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paymentMethodTitleLabel.mas_bottom).offset(kWZOrderInfoTableViewCellEdgeInsets.top);
            make.left.bottom.equalTo(self.contentView).insets(kWZOrderInfoTableViewCellEdgeInsets);
        }];
        [self.orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderIdTitleLabel.mas_right).offset(kWZOrderInfoTableViewCellEdgeInsets.right);
            make.centerY.equalTo(self.orderIdTitleLabel);
        }];
        [self.orderTimeStampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderTimeStampTitleLabel.mas_right).offset(kWZOrderInfoTableViewCellEdgeInsets.right);
            make.centerY.equalTo(self.orderTimeStampTitleLabel);
        }];
        [self.paymentMethodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.paymentMethodTitleLabel.mas_right).offset(kWZOrderInfoTableViewCellEdgeInsets.right);
            make.centerY.equalTo(self.paymentMethodTitleLabel);
        }];
        [self.paymentTimeStampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.paymentTimeStampTitleLabel.mas_right).offset(kWZOrderInfoTableViewCellEdgeInsets.right);
            make.centerY.equalTo(self.paymentTimeStampTitleLabel);
        }];
    }
    return self;
}

#pragma mark - LazyLoad

- (UILabel *)orderIdTitleLabel {
    if (!_orderIdTitleLabel) {
        _orderIdTitleLabel = [[UILabel alloc] init];
        _orderIdTitleLabel.text = @"订单编号：";
        _orderIdTitleLabel.font = [UIFont systemFontOfSize:kWZOrderInfoTableViewCellFontSize];
    }
    return _orderIdTitleLabel;
}

- (UILabel *)orderTimeStampTitleLabel {
    if (!_orderTimeStampTitleLabel) {
        _orderTimeStampTitleLabel = [[UILabel alloc] init];
        _orderTimeStampTitleLabel.text = @"下单时间：";
        _orderTimeStampTitleLabel.font = [UIFont systemFontOfSize:kWZOrderInfoTableViewCellFontSize];
    }
    return _orderTimeStampTitleLabel;
}

- (UILabel *)paymentMethodTitleLabel {
    if (!_paymentMethodTitleLabel) {
        _paymentMethodTitleLabel = [[UILabel alloc] init];
        _paymentMethodTitleLabel.text = @"支付方式：";
        _paymentMethodTitleLabel.font = [UIFont systemFontOfSize:kWZOrderInfoTableViewCellFontSize];
    }
    return _paymentMethodTitleLabel;
}

- (UILabel *)paymentTimeStampTitleLabel {
    if (!_paymentTimeStampTitleLabel) {
        _paymentTimeStampTitleLabel = [[UILabel alloc] init];
        _paymentTimeStampTitleLabel.text = @"支付时间：";
        _paymentTimeStampTitleLabel.font = [UIFont systemFontOfSize:kWZOrderInfoTableViewCellFontSize];
    }
    return _paymentTimeStampTitleLabel;
}

- (UILabel *)orderIdLabel {
    if (!_orderIdLabel) {
        _orderIdLabel = [[UILabel alloc] init];
        _orderIdLabel.font = [UIFont systemFontOfSize:kWZOrderInfoTableViewCellFontSize];
    }
    return _orderIdLabel;
}

- (UILabel *)orderTimeStampLabel {
    if (!_orderTimeStampLabel) {
        _orderTimeStampLabel = [[UILabel alloc] init];
        _orderTimeStampLabel.font = [UIFont systemFontOfSize:kWZOrderInfoTableViewCellFontSize];
    }
    return _orderTimeStampLabel;
}

- (UILabel *)paymentMethodLabel {
    if (!_paymentMethodLabel) {
        _paymentMethodLabel = [[UILabel alloc] init];
        _paymentMethodLabel.font = [UIFont systemFontOfSize:kWZOrderInfoTableViewCellFontSize];
    }
    return _paymentMethodLabel;
}

- (UILabel *)paymentTimeStampLabel {
    if (!_paymentTimeStampLabel) {
        _paymentTimeStampLabel = [[UILabel alloc] init];
        _paymentTimeStampLabel.font = [UIFont systemFontOfSize:kWZOrderInfoTableViewCellFontSize];
    }
    return _paymentTimeStampLabel;
}

@end
