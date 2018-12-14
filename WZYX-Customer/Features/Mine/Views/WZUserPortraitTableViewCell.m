//
//  WZUserPortraitTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/26.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZUserPortraitTableViewCell.h"
#import "Masonry.h"

#define kWZUserPortraitTableViewCellAvatarImageViewSize         CGSizeMake(60, 60)
#define kWZUserPortraitTableViewCellEdgeInsets                  UIEdgeInsetsMake(13.5, 15, 13.5, 15)

@implementation WZUserPortraitTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if ([reuseIdentifier isEqualToString:kWZUserPortraitTableViewCellLeft]) {
            [self.contentView addSubview:self.avatarImageView];
            [self.contentView addSubview:self.userNameLabel];
            [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(self.contentView).insets(kWZUserPortraitTableViewCellEdgeInsets);
                make.size.mas_equalTo(kWZUserPortraitTableViewCellAvatarImageViewSize).priority(800);
            }];
            [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.avatarImageView.mas_right).inset(kWZUserPortraitTableViewCellEdgeInsets.right);
                make.right.equalTo(self.contentView).inset(kWZUserPortraitTableViewCellEdgeInsets.right);
                make.centerY.equalTo(self.avatarImageView);
            }];
        } else if ([reuseIdentifier isEqualToString:kWZUserPortraitTableViewCellRight]) {
            [self.contentView addSubview:self.avatarImageView];
            [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(self.contentView).insets(kWZUserPortraitTableViewCellEdgeInsets);
                make.size.mas_equalTo(kWZUserPortraitTableViewCellAvatarImageViewSize).priorityHigh();
            }];
        }
    }
    return self;
}

#pragma mark - LazyLoad

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
    }
    return _avatarImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
    }
    return _userNameLabel;
}

@end
