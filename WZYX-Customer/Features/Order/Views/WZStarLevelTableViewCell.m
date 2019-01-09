//
//  WZStarLevelTableViewCell.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/8.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZStarLevelTableViewCell.h"

#import "Masonry.h"

#define kWZStarLevelTableViewCellEdgeInsets                 UIEdgeInsetsMake(20, 10, 20, 10)
#define kWZStarLevelTableViewCellStarSize                   CGSizeMake(36, 36)

@interface WZStarLevelTableViewCell ()

@property (strong, nonatomic) UILabel *starLabel;
@property (strong, nonatomic) NSArray *starImageViews;
@property (strong, nonatomic) UIImageView *star1ImageView;
@property (strong, nonatomic) UIImageView *star2ImageView;
@property (strong, nonatomic) UIImageView *star3ImageView;
@property (strong, nonatomic) UIImageView *star4ImageView;
@property (strong, nonatomic) UIImageView *star5ImageView;

@end

@implementation WZStarLevelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.starLabel];
        [self.contentView addSubview:self.star1ImageView];
        [self.contentView addSubview:self.star2ImageView];
        [self.contentView addSubview:self.star3ImageView];
        [self.contentView addSubview:self.star4ImageView];
        [self.contentView addSubview:self.star5ImageView];
        [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.contentView).insets(kWZStarLevelTableViewCellEdgeInsets);
        }];
        [self.star5ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.contentView).insets(kWZStarLevelTableViewCellEdgeInsets);
            make.size.mas_equalTo(kWZStarLevelTableViewCellStarSize);
        }];
        [self.star4ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.star5ImageView);
            make.size.mas_equalTo(kWZStarLevelTableViewCellStarSize);
            make.right.equalTo(self.star5ImageView.mas_left).offset(-kWZStarLevelTableViewCellEdgeInsets.right);
        }];
        [self.star3ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.star5ImageView);
            make.size.mas_equalTo(kWZStarLevelTableViewCellStarSize);
            make.right.equalTo(self.star4ImageView.mas_left).offset(-kWZStarLevelTableViewCellEdgeInsets.right);
        }];
        [self.star2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.star5ImageView);
            make.size.mas_equalTo(kWZStarLevelTableViewCellStarSize);
            make.right.equalTo(self.star3ImageView.mas_left).offset(-kWZStarLevelTableViewCellEdgeInsets.right);
        }];
        [self.star1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.star5ImageView);
            make.size.mas_equalTo(kWZStarLevelTableViewCellStarSize);
            make.right.equalTo(self.star2ImageView.mas_left).offset(-kWZStarLevelTableViewCellEdgeInsets.right);
        }];
        
        self.starImageViews = @[self.star1ImageView, self.star2ImageView, self.star3ImageView, self.star4ImageView, self.star5ImageView];
        for (int i = 0; i < 5; i++) {
            UIImageView *starImageView = self.starImageViews[i];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressesStarImageView:)];
            [starImageView addGestureRecognizer:singleTap];
        }
    }
    return self;
}

- (void)pressesStarImageView:(id)sender {
    UITapGestureRecognizer *gestureRecognizer = (UITapGestureRecognizer *)sender;
    NSInteger index = gestureRecognizer.view.tag - 1;
    for (NSInteger i = 0; i <= index; i++) {
        UIImageView *starImageView = self.starImageViews[i];
        starImageView.image = [UIImage imageNamed:@"GoldStar.png"];
    }
    for (NSInteger i = index + 1; i < 5; i++) {
        UIImageView *starImageView = self.starImageViews[i];
        starImageView.image = [UIImage imageNamed:@"DarkStar.png"];
    }
    [self.delegate starLevelTableViewCell:self didGetNewStarLevel:gestureRecognizer.view.tag];
 }

#pragma mark - LazyLoad

- (UILabel *)starLabel {
    if (!_starLabel) {
        _starLabel = [[UILabel alloc] init];
        _starLabel.text = @"为活动打分：";
    }
    return _starLabel;
}

- (UIImageView *)star1ImageView {
    if (!_star1ImageView) {
        _star1ImageView = [[UIImageView alloc] init];
        _star1ImageView.tag = 1;
        _star1ImageView.image = [UIImage imageNamed:@"WhiteStar.png"];
        _star1ImageView.userInteractionEnabled = YES;
    }
    return _star1ImageView;
}

- (UIImageView *)star2ImageView {
    if (!_star2ImageView) {
        _star2ImageView = [[UIImageView alloc] init];
        _star2ImageView.tag = 2;
        _star2ImageView.image = [UIImage imageNamed:@"WhiteStar.png"];
        _star2ImageView.userInteractionEnabled = YES;
    }
    return _star2ImageView;
}

- (UIImageView *)star3ImageView {
    if (!_star3ImageView) {
        _star3ImageView = [[UIImageView alloc] init];
        _star3ImageView.tag = 3;
        _star3ImageView.image = [UIImage imageNamed:@"WhiteStar.png"];
        _star3ImageView.userInteractionEnabled = YES;
    }
    return _star3ImageView;
}

- (UIImageView *)star4ImageView {
    if (!_star4ImageView) {
        _star4ImageView = [[UIImageView alloc] init];
        _star4ImageView.tag = 4;
        _star4ImageView.image = [UIImage imageNamed:@"WhiteStar.png"];
        _star4ImageView.userInteractionEnabled = YES;
    }
    return _star4ImageView;
}

- (UIImageView *)star5ImageView {
    if (!_star5ImageView) {
        _star5ImageView = [[UIImageView alloc] init];
        _star5ImageView.tag = 5;
        _star5ImageView.image = [UIImage imageNamed:@"WhiteStar.png"];
        _star5ImageView.userInteractionEnabled = YES;
    }
    return _star5ImageView;
}

@end
