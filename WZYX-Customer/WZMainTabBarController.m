//
//  WZMainTabBarController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/26.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZMainTabBarController.h"
#import "WZMineNavigationController.h"

@interface WZMainTabBarController ()

@end

@implementation WZMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WZMineNavigationController *mineNavigationController = [WZMineNavigationController defaultMineNavigationController];
    self.viewControllers = @[mineNavigationController];
}

@end
