//
//  WZActivityDetailTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/19.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZActivityDetailTableViewController.h"
#import "WZActivityDetailImageCell.h"

@interface WZActivityDetailTableViewController ()

@end

@implementation WZActivityDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"活动详情";
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//detail image
        WZActivityDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
        if (!cell) {
            cell = [[WZActivityDetailImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ImageCell"];
        }
        cell.textLabel.text = @"假装这是一张图片";
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {//价格
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PriceCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PriceCell"];
            }
            cell.textLabel.text = @"$XXX";
            cell.textLabel.font = [UIFont systemFontOfSize:22];
            cell.textLabel.textColor = [UIColor redColor];
            return cell;
        } else if (indexPath.row == 1) {//活动名称
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityNameCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityNameCell"];
            }
            cell.textLabel.text = @"这是一个测试活动";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
            return cell;
        } else if (indexPath.row == 2) {//活动时间
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TimeCell"];
            }
            cell.textLabel.text = @"活动时间";
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.text = @"2018.12.19";
            cell.detailTextLabel.textColor = [UIColor blackColor];
            return cell;
        }
    }
    return nil;
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.view.bounds.size.width;
    }
    return UITableViewAutomaticDimension;
}
@end
