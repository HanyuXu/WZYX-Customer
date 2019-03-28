//
//  WZActivityCommentTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/3/28.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZActivityCommentTableViewController.h"
#import "WZActivityCommentCell.h"
#import "WZComment.h"

@interface WZActivityCommentTableViewController ()

@property (strong, nonatomic) NSArray *comments;

@end

@implementation WZActivityCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WZComment downloadCommentForEvent:@"E000002" success:^(NSArray * _Nonnull comments) {
        self.comments = comments;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSString * _Nonnull userInfo) {
        // do nothing
    }];
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
    return self.comments.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZActivityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    if (!cell) {
        cell = [[WZActivityCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
    }
    WZComment *comment = [self.comments objectAtIndex:indexPath.row];
    cell.userNameLabel.text = comment.commenter;
    cell.timeLabel.text = comment.commentDate;
    cell.contentLabel.text = comment.commentText;
    
    return cell;
}


@end
