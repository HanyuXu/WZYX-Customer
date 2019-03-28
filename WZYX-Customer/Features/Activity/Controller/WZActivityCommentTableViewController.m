//
//  WZActivityCommentTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/3/28.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZActivityCommentTableViewController.h"
#import "WZActivityCommentCell.h"

@interface WZActivityCommentTableViewController ()

@end

@implementation WZActivityCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.estimatedRowHeight = 44;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZActivityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    if (!cell) {
        cell = [[WZActivityCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
    }
    cell.contentLabel.text = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    return cell;
}


@end
