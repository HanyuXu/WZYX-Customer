//
//  WZAvatarViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/26.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZAvatarViewController.h"
#import <Masonry.h>

@interface WZAvatarViewController ()

@end

@implementation WZAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    self.imageView.image = [UIImage imageNamed:@"Person"];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset((self.view.bounds.size.height-self.view.bounds.size.width)/2);
        make.bottom.equalTo(self.view).offset(-(self.view.bounds.size.height-self.view.bounds.size.width)/2);
    }];
    self.imageView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    self.imageView.layer.borderWidth = 2;
    
    if (self.view == nil) {
        NSLog(@"YES");
    }
}

@end
