//
//  WZPayMethodTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/4.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZPayMethodTableViewCell.h"
#import "Masonry.h"

#define kWZPayMethodTableViewCellLogoViewSize   CGSizeMake(36, 36)
#define kWZPayMethodTableViewCellEdgeInsets     UIEdgeInsetsMake(13.5, 15, 13.5, 15)

@implementation WZPayMethodTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.logoView];
        [self.contentView addSubview:self.nameLabel];
        [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.contentView).insets(kWZPayMethodTableViewCellEdgeInsets);
            make.size.mas_equalTo(kWZPayMethodTableViewCellLogoViewSize).priority(800);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoView.mas_right).inset(kWZPayMethodTableViewCellEdgeInsets.right);
            make.right.equalTo(self.contentView).inset(kWZPayMethodTableViewCellEdgeInsets.right);
            make.centerY.equalTo(self.logoView);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - LazyLoad

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] init];
    }
    return _logoView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

@end
