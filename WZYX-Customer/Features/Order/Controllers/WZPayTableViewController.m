//
//  WZPayTableViewController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/4.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZPayTableViewController.h"
#import "WZOrderTableViewCell.h"
#import "WZOrderPriceTableViewCell.h"
#import "WZPayMethodTableViewCell.h"
#import "WZOrder.h"
#import "WZSubmitButtonView.h"
#import "WZThirdPayMockViewController.h"

@interface WZPayTableViewController () <WZThirdPayMockViewControllerDelegate>

@property (weak, nonatomic) UIButton *submitButton;

@end

@implementation WZPayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付";
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.1)];
    self.tableView.tableHeaderView = headerView;
    self.tableView.sectionFooterHeight = 0;
    
    WZSubmitButtonView *footerView = [[WZSubmitButtonView alloc] init];
    self.submitButton = footerView.submitButton;
    [self.submitButton setTitle:@"前往支付" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(pressesSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WZOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
            if (!cell) {
                cell = [[WZOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderCell"];
            }
            [cell.sponsorNameButton setTitle:self.order.sponsorName forState:UIControlStateNormal];
            cell.eventAvatarImageView.image = [UIImage imageNamed:self.order.eventAvatar];
            cell.eventTitleLabel.text = self.order.eventTitle;
            cell.priceAndCountLabel.text = [NSString stringWithFormat:@"¥ %@\nx %@", self.order.eventPrice, self.order.purchaseCount];
            cell.eventSeasonLabel.text = self.order.eventSeason;
            cell.separatorInset = UIEdgeInsetsMake(0.0, [UIScreen mainScreen].bounds.size.width, 0.0, 0.0);
            return cell;
        } else {
            WZOrderPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPriceCell"];
            if (!cell) {
                cell = [[WZOrderPriceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderPriceCell"];
            }
            cell.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@", self.order.orderAmount];
            cell.discountLabel.text = [NSString stringWithFormat:@"- ¥ %@", self.order.orderDiscount];
            cell.actualPaymentLabel.text = [NSString stringWithFormat:@"¥ %@", self.order.orderAmount];
            return cell;
        }
    } else {
        WZPayMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayMethodCell"];
        if (!cell) {
            cell = [[WZPayMethodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayMethodCell"];
        }
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"支付宝";
            cell.logoView.image = [UIImage imageNamed:@"AliPay.png"];
        } else if (indexPath.row == 1) {
            cell.nameLabel.text = @"微信支付";
            cell.logoView.image = [UIImage imageNamed:@"WeixinPay.png"];
        } else {
            cell.nameLabel.text = @"银联支付";
            cell.logoView.image = [UIImage imageNamed:@"UnionPay.png"];
        }
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"请选择支付方式：";
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
        [tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        return indexPath;
    } else {
        return [self.tableView indexPathForSelectedRow];
    }
}

#pragma mark - WZThirdPayMockViewControllerDelegate

- (void)thirdPayMock:(WZThirdPayMockViewController *)thirdPayMock didFinishPaySuccess:(BOOL)success userInfo:(NSString *)userInfo {
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.delegate payTableViewController:self didFinishPaySuccess:YES userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:userInfo message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

#pragma mark - EventHandlers

- (void)pressesSubmitButton:(UIButton *)button {
    if ([self.tableView indexPathForSelectedRow].section == 1) {
        WZThirdPayMockViewController *thirdPayMockVC;
        if ([self.tableView indexPathForSelectedRow].row == 0) {
            thirdPayMockVC = [WZThirdPayMockViewController thirdPayMockWithPaymentMethod:WZOrderPaymentMethodAlipay];
        } else if ([self.tableView indexPathForSelectedRow].row == 1) {
            thirdPayMockVC = [WZThirdPayMockViewController thirdPayMockWithPaymentMethod:WZOrderPaymentMethodWeChatPay];
        } else {
            thirdPayMockVC = [WZThirdPayMockViewController thirdPayMockWithPaymentMethod:WZOrderPaymentMethodUnionPay];
        }
        thirdPayMockVC.order = self.order;
        thirdPayMockVC.delegate = self;
        [self presentViewController:thirdPayMockVC animated:YES completion:nil];
        [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].accessoryType = UITableViewCellAccessoryNone;
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择付款方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
