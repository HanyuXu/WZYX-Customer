//
//  WZOrderNavigationController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/30.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZOrderNavigationController.h"
#import "WZBaseScrollViewController.h"

@interface WZOrderNavigationController ()

@end

@implementation WZOrderNavigationController

+ (instancetype)defaultOrderNavigationController {
    return [[WZOrderNavigationController alloc] initWithRootViewController:[[WZBaseScrollViewController alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.title = @"订单";
}

@end
