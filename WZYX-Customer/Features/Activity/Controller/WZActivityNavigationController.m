//
//  WZActivityNavigationController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/6.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZActivityNavigationController.h"
#import "WZActivityViewController.h"

@interface WZActivityNavigationController ()

@end

@implementation WZActivityNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.title = @"活动";
    self.tabBarItem.image = [UIImage imageNamed:@"activity"];
}

+ (instancetype)defaultActivityNavigationController {
    return [[self.class alloc] initWithRootViewController:[[WZActivityViewController alloc] init]];
}

@end
