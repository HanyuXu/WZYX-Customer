//
//  WZOrderDetailTableViewController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/10.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZOrderDetailTableViewController.h"
#import "WZOrder.h"
#import "WZOrderStateTableViewCell.h"
#import "WZOrderTableViewCell.h"
#import "WZOrderPriceTableViewCell.h"
#import "WZOrderActionTableViewCell.h"
#import "WZOrderInfoTableViewCell.h"
#import "WZCertificationViewController.h"
#import "WZPayTableViewController.h"
#import "WZCommentTableViewController.h"

#import "MBProgressHUD.h"

@interface WZOrderDetailTableViewController () <WZPayTableViewControllerDelegate, WZCommentTableViewControllerDelegate>

@end

@implementation WZOrderDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.1)];
    self.tableView.tableHeaderView = headerView;
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 5;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WZOrderStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderStateCell"];
        if (!cell) {
            cell = [[WZOrderStateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderStateCell"];
        }
        NSArray *states = @[@"待付款", @"待参与", @"待评价", @"已过期", @"已取消", @"退款中", @"已退款", @"已完成", @"所有状态"];
        cell.orderStateLabel.text = states[self.order.orderState];
        return cell;
    } else if (indexPath.section == 1) {
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
            return cell;
        } else if (indexPath.row == 1) {
            WZOrderPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPriceCell"];
            if (!cell) {
                cell = [[WZOrderPriceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderPriceCell"];
            }
            cell.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@", self.order.orderAmount];
            cell.discountLabel.text = [NSString stringWithFormat:@"- ¥ %@", self.order.orderDiscount];
            cell.actualPaymentLabel.text = [NSString stringWithFormat:@"¥ %@", self.order.actualAmount];
            return cell;
        } else {
            WZOrderActionTableViewCell *cell;
            if (self.order.orderState == WZOrderStateWaitingPayment || self.order.orderState == WZOrderStateWaitingParticipation || self.order.orderState == WZOrderStateWaitingComment || self.order.orderState == WZOrderStateOverdue) {
                cell = [tableView dequeueReusableCellWithIdentifier:kWZOrderActionTableViewCellTwoAction];
                if (!cell) {
                    cell = [[WZOrderActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZOrderActionTableViewCellTwoAction];
                }
                if (self.order.orderState == WZOrderStateWaitingPayment) {
                    [cell.mainButton setTitle:@"立即支付" forState:UIControlStateNormal];
                    [cell.anotherButton setTitle:@"取消订单" forState:UIControlStateNormal];
                } else if (self.order.orderState == WZOrderStateWaitingParticipation) {
                    [cell.mainButton setTitle:@"查看凭证" forState:UIControlStateNormal];
                    [cell.anotherButton setTitle:@"申请退款" forState:UIControlStateNormal];
                } else if (self.order.orderState == WZOrderStateWaitingComment) {
                    [cell.mainButton setTitle:@"立即评价" forState:UIControlStateNormal];
                    [cell.anotherButton setTitle:@"删除订单" forState:UIControlStateNormal];
                } else if (self.order.orderState == WZOrderStateOverdue) {
                    [cell.mainButton setTitle:@"申请退款" forState:UIControlStateNormal];
                    [cell.anotherButton setTitle:@"删除订单" forState:UIControlStateNormal];
                }
                cell.mainButton.tag = indexPath.section;
                cell.anotherButton.tag = indexPath.section;
                [cell.mainButton addTarget:self action:@selector(pressesOrderActionButton:) forControlEvents:UIControlEventTouchUpInside];
                [cell.anotherButton addTarget:self action:@selector(pressesOrderActionButton:) forControlEvents:UIControlEventTouchUpInside];
            } else  {
                cell = [tableView dequeueReusableCellWithIdentifier:kWZOrderActionTableViewCellOneAction];
                if (!cell) {
                    cell = [[WZOrderActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZOrderActionTableViewCellOneAction];
                }
                if (self.order.orderState == WZOrderStateCanceled || self.order.orderState == WZOrderStateRefunded || self.order.orderState == WZOrderStateFinished) {
                    [cell.mainButton setTitle:@"删除订单" forState:UIControlStateNormal];
                } else if (self.order.orderState == WZOrderStateRefunding) {
                    [cell.mainButton setTitle:@"正在退款" forState:UIControlStateNormal];
                }
                cell.mainButton.tag = indexPath.section;
                [cell.mainButton addTarget:self action:@selector(pressesOrderActionButton:) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell;
        }
    } else {
        WZOrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInfoCell"];
        if (!cell) {
            cell = [[WZOrderInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderInfoCell"];
        }
        cell.orderIdLabel.text = self.order.orderId;
        cell.orderTimeStampLabel.text = self.order.orderTimeStamp;
        if (self.order.paymentMethod == WZOrderPaymentMethodAlipay) {
            cell.paymentMethodLabel.text = @"支付宝";
        } else if (self.order.paymentMethod == WZOrderPaymentMethodWeChatPay) {
            cell.paymentMethodLabel.text = @"微信支付";
        } else if (self.order.paymentMethod == WZOrderPaymentMethodUnionPay) {
            cell.paymentMethodLabel.text = @"银联支付";
        }
        cell.paymentTimeStampLabel.text = self.order.paymentTimeStamp;
        return cell;
    }
}

#pragma mark - WZPayTableViewControllerDelegate

- (void)payTableViewController:(WZPayTableViewController *)payVC didFinishPaySuccess:(BOOL)success userInfo:(NSString *)userInfo {
    if (success) {
        [self loadOrderData];
        [self.delegate orderDetailTableViewControllerDidUpdateOrderState:self];
    }
}

#pragma mark - WZCommentTableViewControllerDelegate

- (void)commentTableViewController:(WZCommentTableViewController *)commentVC didFinishCommentSuccess:(BOOL)success userInfo:(NSString *)userInfo {
    if (success) {
        [self loadOrderData];
        [self.delegate orderDetailTableViewControllerDidUpdateOrderState:self];
    }
}

#pragma mark - PrivateMethods

- (void)loadOrderData {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.label.text = @"正在加载";
    progressHUD.contentColor = [UIColor whiteColor];
    progressHUD.bezelView.backgroundColor = [UIColor blackColor];
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.offset = CGPointMake(0, -100);
    [WZOrder loadOrder:self.order.orderId success:^(WZOrder * _Nonnull order) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [progressHUD hideAnimated:YES];
            self.order = order;
            [self.tableView reloadData];
        });
    } failure:^(NSString * _Nonnull userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [progressHUD hideAnimated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}

#pragma mark - EventHandlers

- (void)pressesOrderActionButton:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"立即支付"]) {
        WZPayTableViewController *payVC = [[WZPayTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        payVC.order = self.order;
        payVC.delegate = self;
        payVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payVC animated:YES];
    } else if ([button.titleLabel.text isEqualToString:@"取消订单"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要取消订单吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [WZOrder cancelOrder:self.order.orderId success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadOrderData];
                    [self.delegate orderDetailTableViewControllerDidUpdateOrderState:self];
                });
            } failure:^(NSString * _Nonnull userInfo) {
                NSLog(@"%@", userInfo);
            }];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([button.titleLabel.text isEqualToString:@"查看凭证"]) {
        WZCertificationViewController *certificationVC = [[WZCertificationViewController alloc] init];
        certificationVC.certificationNumber = self.order.certificationNumber;
        certificationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:certificationVC animated:YES];
    } else if ([button.titleLabel.text isEqualToString:@"申请退款"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要申请退款吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [WZOrder refundOrder:self.order.orderId success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadOrderData];
                    [self.delegate orderDetailTableViewControllerDidUpdateOrderState:self];
                });
            } failure:^(NSString * _Nonnull userInfo) {
                NSLog(@"%@", userInfo);
            }];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([button.titleLabel.text isEqualToString:@"立即评价"]) {
        WZCommentTableViewController *commentVC = [[WZCommentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        commentVC.order = self.order;
        commentVC.delegate = self;
        commentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentVC animated:YES];
    } else if ([button.titleLabel.text isEqualToString:@"删除订单"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要永久删除订单吗？" message:@"删除后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [WZOrder deleteOrder:self.order.orderId success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.delegate orderDetailTableViewControllerDidUpdateOrderState:self];
                });
            } failure:^(NSString * _Nonnull userInfo) {
                NSLog(@"%@", userInfo);
            }];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([button.titleLabel.text isEqualToString:@"正在退款"]) {
        
    }
}

@end
