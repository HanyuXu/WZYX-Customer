//
//  WZSubmitButtonView.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/4.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZSubmitButtonView.h"
#import "Masonry.h"

@implementation WZSubmitButtonView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)]) {
        [self addSubview:self.submitButton];
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(36, 18, 0, 18));
        }];
    }
    return self;
}

#pragma mark - LazyLoad

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] init];
        _submitButton.layer.cornerRadius = 10.0;
        _submitButton.backgroundColor = [UIColor redColor];
    }
    return _submitButton;
}

@end
