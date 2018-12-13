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
    self.tabBarItem.image = [UIImage imageNamed:@"Setting"];
    // Do any additional setup after loading the view.
}

+ (instancetype)defaultActivityNavigationController {
    return [[self.class alloc] initWithRootViewController:[[WZActivityViewController alloc] init]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
