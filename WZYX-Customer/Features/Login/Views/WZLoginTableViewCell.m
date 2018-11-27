//
//  WZLoginTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/22.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZLoginTableViewCell.h"

#import "Masonry.h"

#define kWZLoginTableViewCellEdgeInsets         UIEdgeInsetsMake(18, 18, 18, 18)
#define kWZLoginTableViewCellFontSizeLarge      32
#define kWZLoginTableViewCellFontSizeNormal     16
#define kWZLoginTableViewCellFontSizeSmall      14
#define kWZLoginTableViewCellLineWidth          0.5
#define kWZLoginTableViewCellSubmitButtonHeight 44
#define kWZLoginTableViewCellPhoneButtonWidth   30

@interface WZLoginTableViewCell () <UITextFieldDelegate>

@property (strong, nonatomic) UIView *line;

@end

@implementation WZLoginTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([reuseIdentifier isEqualToString:kWZLoginTableViewCellForLabel]) {
            [self.contentView addSubview:self.label];
            [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).insets(kWZLoginTableViewCellEdgeInsets);
            }];
        } else if ([reuseIdentifier isEqualToString:kWZLoginTableViewCellForPhoneNumber]) {
            UIView *splitLine = [[UIView alloc] init];
            splitLine.backgroundColor = [UIColor grayColor];
            [self.contentView addSubview:self.button];
            [self.contentView addSubview:splitLine];
            [self.contentView addSubview:self.textField];
            [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(self.contentView).insets(kWZLoginTableViewCellEdgeInsets);
                make.width.mas_equalTo(kWZLoginTableViewCellPhoneButtonWidth);
            }];
            [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.contentView).insets(kWZLoginTableViewCellEdgeInsets);
                make.left.equalTo(self.button.mas_right).offset(kWZLoginTableViewCellEdgeInsets.right);
                make.width.mas_equalTo(kWZLoginTableViewCellLineWidth);
            }];
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(self.contentView).insets(kWZLoginTableViewCellEdgeInsets);
                make.left.equalTo(splitLine.mas_right).offset(kWZLoginTableViewCellEdgeInsets.right);
            }];
            [self addLineAsSubview];
            self.textField.keyboardType = UIKeyboardTypePhonePad;
            self.textField.placeholder = @"手机号码";
        } else if ([reuseIdentifier isEqualToString:kWZLoginTableViewCellForPassword]) {
            [self.contentView addSubview:self.textField];
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).insets(kWZLoginTableViewCellEdgeInsets);
            }];
            [self addLineAsSubview];
            self.textField.secureTextEntry = YES;
            self.textField.placeholder = @"密码";
        } else if ([reuseIdentifier isEqualToString:kWZLoginTableViewCellForVerification]) {
            [self.contentView addSubview:self.textField];
            [self.contentView addSubview:self.button];
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(self.contentView).insets(kWZLoginTableViewCellEdgeInsets);
            }];
            [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(self.contentView).insets(kWZLoginTableViewCellEdgeInsets);
                make.left.equalTo(self.textField.mas_right).offset(kWZLoginTableViewCellEdgeInsets.left);
            }];
            [self addLineAsSubview];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.textField.placeholder = @"验证码";
        } else if ([reuseIdentifier isEqualToString:kWZLoginTableViewCellForButton]) {
            [self.contentView addSubview:self.button];
            [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(self.contentView).insets(kWZLoginTableViewCellEdgeInsets);
            }];
        } else if ([reuseIdentifier isEqualToString:kWZLoginTableViewCellForSubmitButton]) {
            [self.contentView addSubview:self.submitButton];
            [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kWZLoginTableViewCellSubmitButtonHeight);
                make.edges.equalTo(self.contentView).insets(kWZLoginTableViewCellEdgeInsets);
            }];
        } else if ([reuseIdentifier isEqualToString:kWZLoginTableViewCellForLabelAndButton]) {
            UIView *centerView = [[UIView alloc] init];
            [self.contentView addSubview:centerView];
            [centerView addSubview:self.label];
            [centerView addSubview:self.button];
            [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.contentView);
                make.center.equalTo(self.contentView);
            }];
            [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(centerView).insets(kWZLoginTableViewCellEdgeInsets);
            }];
            [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(centerView).insets(kWZLoginTableViewCellEdgeInsets);
                make.left.equalTo(self.label.mas_right);
                make.baseline.equalTo(self.label.mas_baseline);
            }];
            self.label.font = [UIFont systemFontOfSize:kWZLoginTableViewCellFontSizeSmall];
        }
    }
    return self;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.line.backgroundColor = [UIColor blueColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.line.backgroundColor = [UIColor grayColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - PrivateMethods

- (void) addLineAsSubview {
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kWZLoginTableViewCellLineWidth);
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView).insets(kWZLoginTableViewCellEdgeInsets);
    }];
}

#pragma mark - LazyLoad

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:kWZLoginTableViewCellFontSizeLarge];
    }
    return _label;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:kWZLoginTableViewCellFontSizeNormal];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.titleLabel.font = [UIFont systemFontOfSize:kWZLoginTableViewCellFontSizeSmall];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _button;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] init];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:kWZLoginTableViewCellFontSizeNormal];
        _submitButton.backgroundColor = [UIColor blueColor];
    }
    return _submitButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor grayColor];
    }
    return _line;
}

@end
