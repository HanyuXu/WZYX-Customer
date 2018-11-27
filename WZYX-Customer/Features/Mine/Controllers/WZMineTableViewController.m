//
//  WZMineTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/23.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZMineTableViewController.h"
#import "WZUserPortraitTableViewCell.h"
#import "WZSubmitButtonTableViewCell.h"
#import "WZMyProfileTableViewController.h"
#import "WZLoginNavigationController.h"

@interface WZMineTableViewController ()

@end

@implementation WZMineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WZUserPortraitTableViewCell *cell = [[WZUserPortraitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZUserPortraitTableViewCellLeft];
        cell.avatarImageView.image = [UIImage imageNamed:@"Person"];
        cell.userNameLabel.text = @"测试一个非常非常非常非常非常非常非常长的名字";
        return cell;
    } else if (indexPath.section == 4) {
        WZSubmitButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubmitCell"];
        if (!cell) {
            cell = [[WZSubmitButtonTableViewCell alloc] init];
        }
        [cell.submitButton setTitle:@"登录 / 注册" forState:UIControlStateNormal];
        [cell.submitButton addTarget:self action:@selector(pressesLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
        cell.imageView.image = [UIImage imageNamed:@"Setting"];
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"钱包";
            } else {
                cell.textLabel.text = @"收藏";
            }
        } else if (indexPath.section == 2) {
            cell.textLabel.text = @"设置";
        } else {
            cell.textLabel.text = @"关于";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        WZMyProfileTableViewController *myProfileVC = [[WZMyProfileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        myProfileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myProfileVC animated:YES];
    }
}

#pragma mark - EventHandlers

- (void)pressesLoginButton:(UIButton *)button {
    WZLoginNavigationController *loginVC = [WZLoginNavigationController defaultLoginNavigationController];
    [self presentViewController:loginVC animated:YES completion:nil];
}

@end
