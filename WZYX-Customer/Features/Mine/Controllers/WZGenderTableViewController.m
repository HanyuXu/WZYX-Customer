//
//  WZGenderTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/24.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZGenderTableViewController.h"
#import "WZUserInfoManager.h"
#import "WZUser.h"

@interface WZGenderTableViewController ()

@end

@implementation WZGenderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *changeGenderButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(changeGenderButtonPressed:)];
    self.navigationItem.rightBarButtonItem = changeGenderButton;
    self.tableView.allowsSelection = YES;
}

#pragma mark - EventHandlers

- (void)changeGenderButtonPressed:(UIButton *)sender {
    if ([self.tableView indexPathForSelectedRow] != nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSIndexPath *selectedIndex= [self.tableView indexPathForSelectedRow];
        int genderIndex = selectedIndex.row == 0 ? 0 : 1;
        NSNumber *gender = [[NSNumber alloc] initWithInt:genderIndex];
        NSDictionary *param = @{@"authToken" : [userDefaults objectForKey:@"authToken"], @"gender" : gender};
        [WZUserInfoManager updateUserInfoWithPrameters:param success:^{
            NSString *genderString = genderIndex == 0 ? @"男" : @"女";
            [WZUser sharedUser].gender = genderString;
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString * _Nonnull userInfo) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GenderCell"];
    NSString *gender = [WZUser sharedUser].gender;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GenderCell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"男";
        if ([gender isEqualToString:@"男"]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.selected = YES;
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        cell.textLabel.text = @"女";
        if ([gender isEqualToString:@"女"]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.selected = YES;
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
    [tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}

@end
