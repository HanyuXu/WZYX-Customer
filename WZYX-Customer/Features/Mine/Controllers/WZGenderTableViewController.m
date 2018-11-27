//
//  WZGenderTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/24.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZGenderTableViewController.h"

@interface WZGenderTableViewController ()

@end

@implementation WZGenderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(setGenderButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.tableView.allowsSelection = YES;
}

- (void)setGenderButtonPressed:(UIButton *)sender {
//    if ([self.tableView indexPathForSelectedRow] != nil) {
//        NSIndexPath *selectedIndex= [self.tableView indexPathForSelectedRow];
//        if(selectedIndex.row != self.user.gender){
//            self.user.gender = selectedIndex.row;
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
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
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GenderCell"];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"男";
//            if (self.user.gender == male) {
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//            }
        } else {
            cell.textLabel.text=@"女";
//            if (self.user.gender == female) {
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                cell.selected = YES;
//                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//            }
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
