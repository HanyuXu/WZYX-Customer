//
//  WZLoginNavigationController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/22.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZLoginNavigationController.h"
#import "WZLoginViewController.h"
#import "WZModifyPasswordViewController.h"

@interface WZLoginNavigationController ()

@end

@implementation WZLoginNavigationController

+ (instancetype)defaultLoginNavigationController {
    return [[self.class alloc] initWithRootViewController:[[WZLoginViewController alloc] init]];
}

+ (instancetype)defaultModifyPasswordNavigationController {
    return [[self.class alloc] initWithRootViewController:[[WZModifyPasswordViewController alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.clipsToBounds = YES;
}

@end
