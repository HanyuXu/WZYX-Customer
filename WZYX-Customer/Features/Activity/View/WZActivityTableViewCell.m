//
//  WZActivityTableViewCell.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/14.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZActivityTableViewCell.h"
#import <Masonry.h>

@implementation WZActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.activityImageView];
        [self.contentView addSubview:self.activityNameLabel];
        [self.contentView addSubview:self.activityDateLabel];
        [self.contentView addSubview:self.activityPirceLabel];
        [self.contentView addSubview:self.activityLocationLabel];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [self.activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
    }];
    [self.activityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityImageView).offset(110);
        make.top.equalTo(self.contentView).offset(10);
    }];
    [self.activityDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activityNameLabel).offset(30);
        make.left.equalTo(self.activityNameLabel);
    }];
    [self.activityPirceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityNameLabel);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    [self.activityLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityNameLabel);
        make.bottom.equalTo(self.contentView).offset(-40);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - LazyLoad

- (UIImageView *)activityImageView {
    if (!_activityImageView) {
        _activityImageView = [[UIImageView alloc] init];
        _activityImageView.image = [UIImage imageNamed:@"Setting"];
    }
    return _activityImageView;
}

- (UILabel *)activityNameLabel {
    if (!_activityNameLabel) {
        _activityNameLabel = [[UILabel alloc] init];
        _activityNameLabel.text = @"2019 China Joy 漫展";
        _activityNameLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _activityNameLabel;
}

- (UILabel *)activityDateLabel{
    if (!_activityDateLabel) {
        _activityDateLabel = [[UILabel alloc] init];
        _activityDateLabel.text = @"活动日期：2.11-2.12";
        _activityDateLabel.textColor = [UIColor grayColor];
        _activityDateLabel.font = [UIFont  systemFontOfSize:14];
    }
    return _activityDateLabel;
}

- (UILabel *)activityPirceLabel {
    if (!_activityPirceLabel) {
        _activityPirceLabel = [[UILabel alloc] init];
        _activityPirceLabel.text = @"￥666.0";
        _activityPirceLabel.textColor = [UIColor redColor];
        _activityPirceLabel.font = [UIFont systemFontOfSize:16];
        
    }
    return _activityPirceLabel;
}

- (UILabel *)activityLocationLabel {
    if (!_activityLocationLabel) {
        _activityLocationLabel = [[UILabel alloc] init];
        _activityLocationLabel.text = @"活动地点：上海";
        _activityLocationLabel.textColor = [UIColor grayColor];
        _activityLocationLabel.font = [UIFont  systemFontOfSize:14];
    }
    return _activityLocationLabel;
}

@end
