//
//  WZNoContentView.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/7.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZNoContentView.h"
#import "Masonry.h"

@interface WZNoContentView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;

@end

@implementation WZNoContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-100);
            make.size.mas_equalTo(CGSizeMake(100, 100)).priority(800);
        }];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.imageView.mas_bottom).offset(20);
        }];
    }
    return self;
}

- (void)setType:(WZNoContentViewType)type {
    _type = type;
    if (_type == WZNoContentViewTypeNetwork) {
        _imageView.image = [UIImage imageNamed:@"Network.png"];
        _label.text = @"网络连接不可用";
    } else if (self.type == WZNoContentViewTypeOrder) {
        _imageView.image = [UIImage imageNamed:@"Order.png"];
        _label.text = @"您还没有相关的订单";
    }
}

#pragma mark - LazyLoad

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor grayColor];
    }
    return _label;
}

@end
