//
//  WZSettingsTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/29.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZSettingsTableViewController.h"
#import "WZCenterLabelTableViewCell.h"
#import "WZUserInfoManager.h"
#import "WZLoginNavigationController.h"
#import "WZLogin.h"

@interface WZSettingsTableViewController ()

@end

@implementation WZSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SimpleCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleCell"];
        }
        cell.textLabel.text = @"修改密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (indexPath.section == 1) {
        WZCenterLabelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CenterLabelCell"];
        if (!cell) {
            cell = [[WZCenterLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CenterLabelCell"];
        }
        cell.centerLabel.text = @"切换账号";
        return cell;
    } else {
        WZCenterLabelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CenterLabelCell"];
        if (!cell) {
            cell = [[WZCenterLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CenterLabelCell"];
        }
        cell.centerLabel.text = @"退出登录";
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![WZUserInfoManager userIsLoggedIn]) {
        [self showAlertViewWithTitle:@"尚未登录" message:@"请先登录以修改信息"];
        return;
    }
    if (indexPath.section == 0) {
        [self presentViewController:[WZLoginNavigationController defaultModifyPasswordNavigationController] animated:YES completion:nil];
    } else if (indexPath.section == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"切换账号" message:@"确定要切换账号？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [WZLogin logoutSuccess:^{
                [WZUserInfoManager clearCurrentUser];
                [self.navigationController popViewControllerAnimated: YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldPresentLoginView" object:nil];
            } failure:^(NSString * _Nonnull userInfo) {
                [self showAlertViewWithTitle:@"错误" message:@"用户没有正常退出"];
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (indexPath.section == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [WZLogin logoutSuccess:^{
                [WZUserInfoManager clearCurrentUser];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString * _Nonnull userInfo) {
                [self showAlertViewWithTitle:@"错误" message:@"用户没有正常退出"];
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - PrivateMethods

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
