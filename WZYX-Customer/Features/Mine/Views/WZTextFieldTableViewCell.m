//
//  WZTextFieldTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/26.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZTextFieldTableViewCell.h"
#import "Masonry.h"

#define kWZTextFieldTableViewCellEdgeInsets     UIEdgeInsetsMake(13.5, 15, 13.5, 15)

@implementation WZTextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(kWZTextFieldTableViewCellEdgeInsets);
        }];
    }
    return self;
}

#pragma mark - LazyLoad

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

@end
