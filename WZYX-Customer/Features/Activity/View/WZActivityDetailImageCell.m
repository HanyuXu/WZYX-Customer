//
//  WZActivityDetailImageCell.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/19.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZActivityDetailImageCell.h"
#import <Masonry.h>

#define WZActivityDetailImageCellInsets UIEdgeInsetsMake(0, 0, 0, 0)

@implementation WZActivityDetailImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.activityImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [self.activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, self.bounds.size.width));
        make.edges.mas_equalTo(self.contentView).insets(WZActivityDetailImageCellInsets);
    }];
}

#pragma mark - LazyLoad

- (UIImageView *)activityImageView{
    if (!_activityImageView) {
        _activityImageView = [[UIImageView alloc] init];
        _activityImageView.image = [UIImage imageNamed:@"Setting"];
    }
    return _activityImageView;
}

@end
