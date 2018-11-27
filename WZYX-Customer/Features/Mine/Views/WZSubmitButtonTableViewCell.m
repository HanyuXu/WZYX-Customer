//
//  WZSubmitButtonTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/26.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZSubmitButtonTableViewCell.h"
#import "Masonry.h"

#define kWZSubmitButtonTableViewCellEdgeInsets              UIEdgeInsetsMake(18, 18, 18, 18)

@implementation WZSubmitButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.submitButton];
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(kWZSubmitButtonTableViewCellEdgeInsets);
        }];
    }
    return self;
}

#pragma mark - LazyLoad

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] init];
        [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _submitButton;
}

@end
