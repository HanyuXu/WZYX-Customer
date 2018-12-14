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
#import "WZSettingsTableViewController.h"
#import "WZUserInfoManager.h"
#import "WZUser.h"

@interface WZMineTableViewController ()

@end

@implementation WZMineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    
    if ([WZUserInfoManager userIsLoggedIn]) {
        [WZUserInfoManager loadUserInfo];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldPresentLoginView:) name:@"shouldPresentLoginView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldLoadUserInfo:) name:@"shouldLoadUserInfo" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WZUserPortraitTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kWZUserPortraitTableViewCellLeft];
        if (!cell) {
            cell = [[WZUserPortraitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZUserPortraitTableViewCellLeft];
        }
        WZUser *user = [WZUser sharedUser];
        cell.avatarImageView.image = [WZUserInfoManager userPortrait];
        if ([WZUserInfoManager userIsLoggedIn]) {
            cell.userNameLabel.text =user.userName;
        } else {
            cell.userNameLabel.text = @"登录 / 注册";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
        }
        cell.imageView.image = [UIImage imageNamed:@"Setting"];
        cell.textLabel.text = @"收藏";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
        }
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"Setting"];
            cell.textLabel.text = @"设置";
        } else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"Setting"];
            cell.textLabel.text = @"关于";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([WZUserInfoManager userIsLoggedIn]) {
            WZMyProfileTableViewController *myProfileVC = [[WZMyProfileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            myProfileVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myProfileVC animated:YES];
        } else {
            WZLoginNavigationController *loginVC = [WZLoginNavigationController defaultLoginNavigationController];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    } else if (indexPath.section == 1) {
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            WZSettingsTableViewController *settingsVC = [[WZSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            settingsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingsVC animated:YES];
        }
    }
}

#pragma mark - EventHandlers

- (void)shouldPresentLoginView:(NSNotification *)notification {
    WZLoginNavigationController *loginVC = [WZLoginNavigationController defaultLoginNavigationController];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)shouldLoadUserInfo:(NSNotification *)notificaiton {
    [WZUserInfoManager loadUserInfo];
    [self.tableView reloadData];
}

@end
