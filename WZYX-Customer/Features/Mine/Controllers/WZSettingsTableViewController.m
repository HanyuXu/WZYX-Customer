//
//  WZSettingsTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/29.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZSettingsTableViewController.h"
#import "WZSettingsTableViewCell.h"
#import "WZModifyPasswordViewController.h"
#import "WZUserInfoManager.h"
#import "WZLoginNavigationController.h"

@interface WZSettingsTableViewController ()

@end

@implementation WZSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)showAlertViewWithTitle:(NSString *)title Message:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"SimpleCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleCell"];
        }
        cell.textLabel.text = @"修改密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else if (indexPath.section == 1) {
        WZSettingsTableViewCell *swithAccountCell = [self.tableView dequeueReusableCellWithIdentifier:kWZTextLabelCellCenter];
        if (!swithAccountCell) {
            swithAccountCell = [[WZSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZTextLabelCellCenter];
        }
        swithAccountCell.WZtextLabel.text = @"切换账号";
        swithAccountCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return swithAccountCell;
    } else if (indexPath.section == 2) {
        WZSettingsTableViewCell *logOutCell = [self.tableView dequeueReusableCellWithIdentifier:kWZTextLabelCellCenter];
        if (!logOutCell) {
            logOutCell = [[WZSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZTextLabelCellCenter];
        }
        logOutCell.WZtextLabel.text = @"退出登录";
        logOutCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return logOutCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![WZUserInfoManager userIsLoggedIn]) {
        [self showAlertViewWithTitle:@"尚未登录" Message:@"请先登录以修改信息"];
        return;
    }
    if (indexPath.section == 0 ) {//change password;
        [self presentViewController:[WZLoginNavigationController defaultModifyPasswordNavigationController] animated:YES completion:nil];
    } else if (indexPath.section == 1) {//switch account
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:alert animated:YES completion:nil];
            [WZUserInfoManager clearCurrentUser];
            [self.navigationController popViewControllerAnimated: YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldPresentLoginView" object:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (indexPath.section == 2) {// logout
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"切换账号" message:@"确定要切换账号？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [WZUserInfoManager clearCurrentUser];
            [self.navigationController popViewControllerAnimated:YES];

        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
