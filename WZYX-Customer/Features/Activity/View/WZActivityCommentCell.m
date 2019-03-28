//
//  WZActivityCommentCell.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/3/28.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZActivityCommentCell.h"
#import "WZActivityRankView.h"
#import <Masonry.h>

@implementation WZActivityCommentCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.rankView];
        [self.contentView addSubview:self.contentLabel];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(10);
        }];
        //[self.contentView layoutIfNeeded];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(20);
        }];
        [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userNameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 15));
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            // NSLog(@"%f", self.userNameLabel.bounds.size.height);
            make.top.equalTo(self.rankView.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    //[super layoutSubviews];
}

#pragma makr - lazy load
- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.text = @"这是用户名";
        _userNameLabel.font = [UIFont systemFontOfSize:15];
        _userNameLabel.textColor = [UIColor lightGrayColor];
        _userNameLabel.backgroundColor = [UIColor greenColor];
    }
    return _userNameLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"2019-3-28";
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.backgroundColor = [UIColor blueColor];
    }
    return _timeLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor redColor];
       // [_contentLabel sizeToFit];
    }
    return _contentLabel;
}

- (WZActivityRankView *)rankView {
    if (!_rankView) {
        _rankView = [[WZActivityRankView alloc] init];
    }
    return _rankView;
}

@end
