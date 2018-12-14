//
//  WZOrderActionTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/10.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZOrderActionTableViewCell.h"

#import "Masonry.h"

#define kWZOrderActionTableViewCellEdgeInsets           UIEdgeInsetsMake(10, 15, 10, 15)
#define kWZOrderActionTableViewCellButtonInnerInsets    UIEdgeInsetsMake(2, 10, 2, 10)
#define kWZOrderActionTableViewCellFontSize             14

@implementation WZOrderActionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.mainButton];
        [self.mainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.contentView).insets(kWZOrderActionTableViewCellEdgeInsets);
        }];
        [self.mainButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.mainButton).insets(kWZOrderActionTableViewCellButtonInnerInsets);
        }];
        
        if ([reuseIdentifier isEqualToString:kWZOrderActionTableViewCellTwoAction]) {
            [self.contentView addSubview:self.anotherButton];
            [self.anotherButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mainButton);
                make.right.equalTo(self.mainButton.mas_left).offset(-kWZOrderActionTableViewCellEdgeInsets.left);
            }];
            [self.anotherButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.anotherButton).insets(kWZOrderActionTableViewCellButtonInnerInsets);
            }];
        }
    }
    return self;
}

#pragma mark - LazyLoad

- (UIButton *)mainButton {
    if (!_mainButton) {
        _mainButton = [[UIButton alloc] init];
        _mainButton.titleLabel.font = [UIFont systemFontOfSize:kWZOrderActionTableViewCellFontSize];
        [_mainButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _mainButton.layer.cornerRadius = 16;
        _mainButton.layer.masksToBounds = YES;
        _mainButton.layer.borderColor = [UIColor redColor].CGColor;
        _mainButton.layer.borderWidth = 0.5;
    }
    return _mainButton;
}

- (UIButton *)anotherButton {
    if (!_anotherButton) {
        _anotherButton = [[UIButton alloc] init];
        _anotherButton.titleLabel.font = [UIFont systemFontOfSize:kWZOrderActionTableViewCellFontSize];
        [_anotherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _anotherButton.layer.cornerRadius = 16;
        _anotherButton.layer.masksToBounds = YES;
        _anotherButton.layer.borderColor = [UIColor grayColor].CGColor;
        _anotherButton.layer.borderWidth = 0.5;
    }
    return _anotherButton;
}

@end
