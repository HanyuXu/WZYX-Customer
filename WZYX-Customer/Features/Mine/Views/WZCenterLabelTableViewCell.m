//
//  WZSettingsTableViewCell.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/29.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZCenterLabelTableViewCell.h"
#import <Masonry.h>

#define kWZCenterLabelTableViewCellInsets  UIEdgeInsetsMake(13.5, 15, 13.5, 15)

@implementation WZCenterLabelTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.centerLabel];
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(kWZCenterLabelTableViewCellInsets);
        }];
    }
    return self;
}

#pragma mark - LazyLoad

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _centerLabel;
}

@end
