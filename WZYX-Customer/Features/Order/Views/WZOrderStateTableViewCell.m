//
//  WZOrderStateTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/10.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZOrderStateTableViewCell.h"

#import "Masonry.h"

@implementation WZOrderStateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.orderStateLabel];
        self.backgroundColor = [UIColor redColor];
        [self.orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(50, 15, 50, 15));
            make.centerX.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - LazyLoad

- (UILabel *)orderStateLabel {
    if (!_orderStateLabel) {
        _orderStateLabel = [[UILabel alloc] init];
        _orderStateLabel.textColor = [UIColor whiteColor];
    }
    return _orderStateLabel;
}

@end
