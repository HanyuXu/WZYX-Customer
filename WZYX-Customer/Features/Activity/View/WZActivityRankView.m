//
//  WZActivityRankView.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/3/28.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZActivityRankView.h"
#import <Masonry.h>

@implementation WZActivityRankView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        for (int i = 0; i < 5; ++i){
            [self addSubview:self.rankImageArray[i]];
        }
        [self.rankImageArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:15 leadSpacing:5 tailSpacing:5];
        [self.rankImageArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}
- (NSArray<UIImageView *> *)rankImageArray {
    if (!_rankImageArray) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
        for (int i = 0; i < 5; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
            [array addObject:imageView];
            imageView.image = [UIImage imageNamed:@"DarkStar"];
        }
        _rankImageArray = [array copy];
    }
    return _rankImageArray;
}



@end
