//
//  WZSettingsTableViewCell.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/29.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZSettingsTableViewCell.h"
#import <Masonry.h>

#define kWZTextLabelCellInsets  UIEdgeInsetsMake(13.5, 15, 13.5, 15)

@implementation WZSettingsTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        if([reuseIdentifier isEqualToString:kWZTextLabelCellCenter]) {
            [self.contentView addSubview:self.WZtextLabel];
            [self.WZtextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.contentView).insets(kWZTextLabelCellInsets);
                make.centerX.equalTo(self.contentView);
                make.centerX.equalTo(self.contentView);
            }];
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(UILabel *)WZtextLabel {
    if(!_WZtextLabel) {
        _WZtextLabel = [[UILabel alloc] init];
    }
    return _WZtextLabel;
}

@end
