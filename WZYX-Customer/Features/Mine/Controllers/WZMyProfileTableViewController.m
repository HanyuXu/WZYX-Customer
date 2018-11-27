//
//  WZMyProfileTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/23.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZMyProfileTableViewController.h"
#import "WZUserPortraitTableViewCell.h"
#import "WZAvatarViewController.h"
#import "WZNameTableViewController.h"
#import "WZGenderTableViewController.h"
#import "WZLoginNavigationController.h"

@interface WZMyProfileTableViewController ()

@end

@implementation WZMyProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        WZUserPortraitTableViewCell *cell = [[WZUserPortraitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZUserPortraitTableViewCellRight];
        cell.textLabel.text = @"头像";
        cell.avatarImageView.image = [UIImage imageNamed:@"Person"];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text = @"测试一个非常非常非常非常非常非常非常长的名字";
        } else if (indexPath.section == 0 && indexPath.row == 2) {
            cell.textLabel.text = @"手机号";
            cell.detailTextLabel.text = @"13800000000";
        } else if (indexPath.section == 0 && indexPath.row == 3) {
            cell.textLabel.text = @"密码";
            cell.detailTextLabel.text = @"修改密码";
        } else if (indexPath.section == 1 && indexPath.row == 0){
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = @"男";
        } else {
            cell.textLabel.text = @"地区";
            cell.detailTextLabel.text = @"上海 杨浦";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WZAvatarViewController *avatorVC = [[WZAvatarViewController alloc] init];
            [self.navigationController pushViewController:avatorVC animated:YES];
        } else if (indexPath.row == 1) {
            WZNameTableViewController *nameVC = [[WZNameTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:nameVC animated:YES];
        } else if (indexPath.row == 3) {
            WZLoginNavigationController *loginVC = [WZLoginNavigationController defaultModifyPasswordNavigationController];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            WZGenderTableViewController *genderVC = [[WZGenderTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:genderVC animated:YES];
        }
    }
}

@end
