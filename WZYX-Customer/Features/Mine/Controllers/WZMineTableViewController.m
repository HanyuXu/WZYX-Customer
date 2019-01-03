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
#import "WZUserInfoManager.h"
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
        [WZUserInfoManager downloadPortrait];
   }
//    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldPresentLoginView:) name:@"shouldPresentLoginView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldLoadUserInfo:) name:@"shouldLoadUserInfo" object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
//    if ([WZUserInfoManager userIsLoggedIn]) {
//
//        [WZUserInfoManager downloadPortrait];
//    }
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
    WZUser *user = [WZUser sharedUser];
    UITableViewCell *cell;
    if (indexPath.section == 0) { // AvatorCell
        WZUserPortraitTableViewCell *portraitCell = [self.tableView dequeueReusableCellWithIdentifier:kWZUserPortraitTableViewCellLeft];
        if (!portraitCell) {
            portraitCell = [[WZUserPortraitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZUserPortraitTableViewCellLeft];
        }
        portraitCell.avatarImageView.image = [WZUserInfoManager userPortrait];
        if ([WZUserInfoManager userIsLoggedIn]) {
            portraitCell.userNameLabel.text =user.userName;
        }
        else {
            portraitCell.userNameLabel.text = @"登录 / 注册";
        }
        portraitCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return portraitCell;
    }else if (indexPath.section == 1) { // Favorite
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FavoriteCell"];
        cell.imageView.image = [UIImage imageNamed:@"Setting"];
        cell.textLabel.text = @"收藏";
    }else if(indexPath.section ==2) { // Setting & About
        if (indexPath.row == 0) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
                cell.imageView.image = [UIImage imageNamed:@"Setting"];
                cell.textLabel.text = @"设置";
            }
        }else if (indexPath.row == 1) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"AboutCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AboutCell"];
                cell.imageView.image = [UIImage imageNamed:@"Setting"];
                cell.textLabel.text = @"关于";
            }
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){ //Profile
        if ([WZUserInfoManager userIsLoggedIn]) {
            WZMyProfileTableViewController *myProfileVC = [[WZMyProfileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            myProfileVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myProfileVC animated:YES];
        } else {
            WZLoginNavigationController *loginVC = [WZLoginNavigationController defaultLoginNavigationController];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    } else if(indexPath.section == 1) { //Favorites
        
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) { // Settings
            WZSettingsTableViewController *settingsVC = [[WZSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:settingsVC animated:YES];
        }
    }
}


#pragma mark - EventHandlers

- (void)pressesLoginButton:(UIButton *)button {
    WZLoginNavigationController *loginVC = [WZLoginNavigationController defaultLoginNavigationController];
    [self presentViewController:loginVC animated:YES completion:^(){
        [self.tableView reloadData];
    }];
}

- (void)shouldReloadData:(NSNotification *) notification {
    //[self.tableView reloadData];
}

- (void)shouldPresentLoginView:(NSNotification *) notification {
    WZLoginNavigationController *loginVC = [WZLoginNavigationController defaultLoginNavigationController];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)shouldLoadUserInfo:(NSNotification *) notificaiton {
    [WZUserInfoManager loadUserInfo];
    [WZUserInfoManager downloadPortrait];
    [self.tableView reloadData];
}
@end
