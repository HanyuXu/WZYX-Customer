//
//  WZThirdPayMockViewController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/4.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZThirdPayMockViewController.h"
#import "Masonry.h"

@interface WZThirdPayMockViewController ()

@property (assign, nonatomic) WZOrderPaymentMethod paymentMethod;

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIButton *successButton;
@property (strong, nonatomic) UIButton *failureButton;

@end

@implementation WZThirdPayMockViewController

+ (instancetype)thirdPayMockWithPaymentMethod:(WZOrderPaymentMethod)method {
    WZThirdPayMockViewController *thirdPayMockVC = [[WZThirdPayMockViewController alloc] init];
    thirdPayMockVC.paymentMethod = method;
    return thirdPayMockVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.successButton];
    [self.view addSubview:self.failureButton];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200);
        make.centerX.equalTo(self.view);
    }];
    [self.successButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(80);
        make.centerX.equalTo(self.textLabel);
    }];
    [self.failureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successButton.mas_bottom).offset(80);
        make.centerX.equalTo(self.textLabel);
    }];
}

#pragma mark - EventHandlers

- (void)pressesSuccessButton:(UIButton *)button {
    [WZOrder payOrder:self.order.orderId withPaymentMethod:self.paymentMethod success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate thirdPayMock:self didFinishPaySuccess:YES userInfo:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^(NSString * _Nonnull userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate thirdPayMock:self didFinishPaySuccess:NO userInfo:userInfo];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void)pressesFailureButton:(UIButton *)button {
    [self.delegate thirdPayMock:self didFinishPaySuccess:NO userInfo:@"支付失败"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LazyLoad

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:24];
        if (self.paymentMethod == WZOrderPaymentMethodAlipay) {
            _textLabel.text = [NSString stringWithFormat:@"模拟第三方支付\n支付方式：%@", @"支付宝"];
        } else if (self.paymentMethod == WZOrderPaymentMethodWeChatPay) {
            _textLabel.text = [NSString stringWithFormat:@"模拟第三方支付\n支付方式：%@", @"微信支付"];
        } else {
            _textLabel.text = [NSString stringWithFormat:@"模拟第三方支付\n支付方式：%@", @"银联支付"];
        }
    }
    return _textLabel;
}

- (UIButton *)successButton {
    if (!_successButton) {
        _successButton = [[UIButton alloc] init];
        [_successButton setTitle:@"模拟支付成功" forState:UIControlStateNormal];
        [_successButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_successButton addTarget:self action:@selector(pressesSuccessButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _successButton;
}

- (UIButton *)failureButton {
    if (!_failureButton) {
        _failureButton = [[UIButton alloc] init];
        [_failureButton setTitle:@"模拟支付失败" forState:UIControlStateNormal];
        [_failureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_failureButton addTarget:self action:@selector(pressesFailureButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failureButton;
}

@end
