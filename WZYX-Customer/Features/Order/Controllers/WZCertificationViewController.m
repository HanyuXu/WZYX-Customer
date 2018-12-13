//
//  WZCertificationViewController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/11.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZCertificationViewController.h"

#import "Masonry.h"

#define kWZCertificationViewControllerEdgeInsets           UIEdgeInsetsMake(30, 20, 30, 20)

@interface WZCertificationViewController ()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *certificationNumberLabel;
@property (strong, nonatomic) UIImageView *certificationQRCode;

@end

@implementation WZCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单凭证";
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.left.right.equalTo(self.view).insets(kWZCertificationViewControllerEdgeInsets);
    }];
    
    [self.contentView addSubview:self.certificationNumberLabel];
    [self.contentView addSubview:self.certificationQRCode];
    [self.certificationNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kWZCertificationViewControllerEdgeInsets.top);
        make.centerX.equalTo(self.contentView);
    }];
    [self.certificationQRCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certificationNumberLabel.mas_bottom).offset(kWZCertificationViewControllerEdgeInsets.top);
        make.left.bottom.right.equalTo(self.contentView).insets(kWZCertificationViewControllerEdgeInsets);
        make.height.equalTo(self.certificationQRCode.mas_width).priorityHigh();
    }];
    self.certificationNumberLabel.text = self.certificationNumber;
    [self.view layoutIfNeeded];
    [self createQRCode];
}

#pragma mark - PrivateMethods

- (void)createQRCode {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [self.certificationNumber dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *outputImage = [filter outputImage];
    self.certificationQRCode.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSquareLength:self.certificationQRCode.bounds.size.width];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSquareLength:(CGFloat)squareLength {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(squareLength / CGRectGetWidth(extent), squareLength / CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    return outputImage;
}

#pragma mark - LazyLoad

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 16;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)certificationNumberLabel {
    if (!_certificationNumberLabel) {
        _certificationNumberLabel = [[UILabel alloc] init];
        _certificationNumberLabel.font = [UIFont boldSystemFontOfSize:30];
    }
    return _certificationNumberLabel;
}

- (UIImageView *)certificationQRCode {
    if (!_certificationQRCode) {
        _certificationQRCode = [[UIImageView alloc] init];
        _certificationQRCode.backgroundColor = [UIColor whiteColor];
    }
    return _certificationQRCode;
}

@end
