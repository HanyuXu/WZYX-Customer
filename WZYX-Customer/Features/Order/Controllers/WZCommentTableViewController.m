//
//  WZCommentTableViewController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/7.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZCommentTableViewController.h"
#import "WZOrderTitleTableViewCell.h"
#import "WZStarLevelTableViewCell.h"
#import "WZCommentInputTableViewCell.h"
#import "WZOrder.h"
#import "WZSubmitButtonView.h"

@interface WZCommentTableViewController () <WZStarLevelTableViewCellDelegate>

@property (assign, nonatomic) NSUInteger starLevel;
@property (weak, nonatomic) UITextView *commentTextView;
@property (weak, nonatomic) UIButton *submitButton;

@end

@implementation WZCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加评价";
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.1)];
    self.tableView.tableHeaderView = headerView;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    WZSubmitButtonView *footerView = [[WZSubmitButtonView alloc] init];
    self.submitButton = footerView.submitButton;
    [self.submitButton setTitle:@"发表评价" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(pressesSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WZOrderTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTitleCell"];
        if (!cell) {
            cell = [[WZOrderTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderTitleCell"];
        }
        cell.eventAvatarImageView.image = [UIImage imageNamed:@"Setting"];
        cell.eventTitleLabel.text = self.order.eventTitle;
        cell.eventSeasonLabel.text = self.order.eventSeason;
        return cell;
    } else if (indexPath.row == 1) {
        WZStarLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StarCell"];
        if (!cell) {
            cell = [[WZStarLevelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StarCell"];
        }
        cell.delegate = self;
        return cell;
    } else {
        WZCommentInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        if (!cell) {
            cell = [[WZCommentInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
        }
        self.commentTextView = cell.commentTextView;
        return cell;
    }
}

#pragma mark - WZStarLevelTableViewCellDelegate

- (void)starLevelTableViewCell:(WZStarLevelTableViewCell *)cell didGetNewStarLevel:(NSUInteger)starLevel {
    self.starLevel = starLevel;
}

#pragma mark - EventHandlers

- (void)pressesSubmitButton:(UIButton *)button {
    if (self.starLevel == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"尚未给活动打分" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (self.commentTextView.text.length < 16) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"评论字数不足" message:@"请至少输入16个字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.commentTextView becomeFirstResponder];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self.commentTextView resignFirstResponder];
        [WZOrder commentOrder:self.order.orderId withCommentText:self.commentTextView.text commentlevel:self.starLevel success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"评价成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.delegate commentTableViewController:self didFinishCommentSuccess:YES userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        } failure:^(NSString * _Nonnull userInfo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:userInfo message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }];
    }
}

@end
