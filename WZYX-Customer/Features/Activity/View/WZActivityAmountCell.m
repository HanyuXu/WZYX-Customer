//
//  WZActivityAmountCell.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/3/24.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZActivityAmountCell.h"
#import <Masonry.h>

@interface WZActivityAmountCell()
@property(strong, nonatomic) UIButton *addAmountButton;
@property(strong, nonatomic) UIButton *subAmountButton;
@property(strong, nonatomic) UILabel *amountLabel;
@property(strong, nonatomic) UILabel *leftLabel;
@end

@implementation WZActivityAmountCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.text = @"数量";
        self.textLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.addAmountButton];
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.subAmountButton];
        [self.contentView addSubview:self.leftLabel];
        //self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews {
    [self.addAmountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addAmountButton).offset(-30);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.subAmountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.amountLabel).offset(-30);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - button target
- (void)add {
    if (self.amount < MAX(self.threshold, 99)) {
        self.amount += 1;
        self.amountLabel.text = [NSString stringWithFormat:@"%lu", self.amount];
        [self.amountLabel sizeToFit];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(addActivityAmount)]) {
        [self.delegate addActivityAmount];
    }
}
- (void)sub {
    if (self.amount > 0) {
        self.amount -= 1;
        self.amountLabel.text = [NSString stringWithFormat:@"%lu", self.amount];
        [self.amountLabel sizeToFit];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(subActivityAmount)]) {
        [self.delegate subActivityAmount];
    }
}
#pragma mark - lazy load
- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _amountLabel.text = @"0";
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _amountLabel;
}
- (UIButton *)addAmountButton {
    if (!_addAmountButton) {
        _addAmountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_addAmountButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        [_addAmountButton setTitle:@"+" forState:UIControlStateNormal];
        [_addAmountButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addAmountButton.layer.borderColor = [[UIColor blackColor] CGColor];
        _addAmountButton.layer.borderWidth = 1;
    }
    return _addAmountButton;
}
- (UIButton *)subAmountButton {
    if (!_subAmountButton) {
        _subAmountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_subAmountButton addTarget:self action:@selector(sub) forControlEvents:UIControlEventTouchUpInside];
        [_subAmountButton setTitle:@"-" forState:UIControlStateNormal];
        [_subAmountButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _subAmountButton.layer.borderColor = [[UIColor blackColor] CGColor];
        _subAmountButton.layer.borderWidth = 1;
    }
    return _subAmountButton;
}
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = @"选择数量";
    }
    return _leftLabel;
}
@end
