//
//  WZSettingsTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/29.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZSettingsTableViewController.h"
#import "WZSettingsTableViewCell.h"

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
    } else if (indexPath.section == 1) {
        WZSettingsTableViewCell *swithAccountCell = [self.tableView dequeueReusableCellWithIdentifier:kWZTextLabelCellCenter];
        if (!swithAccountCell) {
            swithAccountCell = [[WZSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZTextLabelCellCenter];
        }
        swithAccountCell.WZtextLabel.text = @"切换账号";
        return swithAccountCell;
    } else if (indexPath.section == 2) {
        WZSettingsTableViewCell *logOutCell = [self.tableView dequeueReusableCellWithIdentifier:kWZTextLabelCellCenter];
        if (!logOutCell) {
            logOutCell = [[WZSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZTextLabelCellCenter];
        }
        logOutCell.WZtextLabel.text = @"退出登录";
        return logOutCell;
    }
    return cell;
}

@end
