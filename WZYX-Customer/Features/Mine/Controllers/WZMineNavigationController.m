//
//  WZMineNavigationController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/26.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZMineNavigationController.h"
#import "WZMineTableViewController.h"

@interface WZMineNavigationController ()

@end

@implementation WZMineNavigationController

+ (instancetype)defaultMineNavigationController {
    return [[self.class alloc] initWithRootViewController:[[WZMineTableViewController alloc] initWithStyle:UITableViewStyleGrouped]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.title = @"我的";
}

@end
