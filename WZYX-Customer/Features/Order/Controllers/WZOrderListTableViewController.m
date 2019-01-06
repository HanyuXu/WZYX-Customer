//
//  WZOrderListTableViewController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/30.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZOrderListTableViewController.h"
#import "WZOrderTableViewCell.h"
#import "WZOrderActionTableViewCell.h"
#import "WZOrderDetailTableViewController.h"
#import "WZCertificationViewController.h"
#import "WZPayTableViewController.h"

#import "MBProgressHUD.h"

@interface WZOrderListTableViewController () <WZOrderDetailTableViewControllerDelegate, WZPayTableViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *orders;

@end

@implementation WZOrderListTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self initWithStyle:style orderState:WZOrderStateAllState];
}

- (instancetype)initWithStyle:(UITableViewStyle)style orderState:(WZOrderState)orderState {
    if (self = [super initWithStyle:style]) {
        self.orderState = orderState;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    self.tableView.tableHeaderView = headerView;
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 5;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WZOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
        if (!cell) {
            cell = [[WZOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderCell"];
        }
        WZOrder *order = self.orders[indexPath.section];
        [cell.sponsorNameButton setTitle:order.sponsorName forState:UIControlStateNormal];
        NSArray *states = @[@"所有状态", @"待付款", @"待参与", @"待评价", @"已过期", @"已取消", @"退款中", @"已退款", @"已完成"];
        cell.orderStateLabel.text = states[order.orderState];
        cell.eventAvatarImageView.image = [UIImage imageNamed:order.eventAvatar];
        cell.eventTitleLabel.text = order.eventTitle;
        cell.priceAndCountLabel.text = [NSString stringWithFormat:@"¥ %@\nx %@", order.eventPrice, order.purchaseCount];
        cell.eventSeasonLabel.text = order.eventSeason;
        cell.orderAmountLabel.text = [NSString stringWithFormat:@"实付款：¥ %@", order.orderAmount];
        return cell;
    } else {
        WZOrderActionTableViewCell *cell;
        WZOrder *order = self.orders[indexPath.section];
        if (order.orderState == WZOrderStateWaitingPayment || order.orderState == WZOrderStateWaitingParticipation || order.orderState == WZOrderStateWaitingComment || order.orderState == WZOrderStateOverdue) {
            cell = [tableView dequeueReusableCellWithIdentifier:kWZOrderActionTableViewCellTwoAction];
            if (!cell) {
                cell = [[WZOrderActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWZOrderActionTableViewCellTwoAction];
            }
            if (order.orderState == WZOrderStateWaitingPayment) {
                [cell.mainButton setTitle:@"立即支付" forState:UIControlStateNormal];
                [cell.anotherButton setTitle:@"取消订单" forState:UIControlStateNormal];
            } else if (order.orderState == WZOrderStateWaitingParticipation) {
                [cell.mainButton setTitle:@"查看凭证" forState:UIControlStateNormal];
                [cell.anotherButton setTitle:@"申请退款" forState:UIControlStateNormal];
            } else if (order.orderState == WZOrderStateWaitingComment) {
                [cell.mainButton setTitle:@"立即评价" forState:UIControlStateNormal];
                [cell.anotherButton setTitle:@"删除订单" forState:UIControlStateNormal];
            } else if (order.orderState == WZOrderStateOverdue) {
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
            if (order.orderState == WZOrderStateCanceled || order.orderState == WZOrderStateRefunded || order.orderState == WZOrderStateFinished) {
                [cell.mainButton setTitle:@"删除订单" forState:UIControlStateNormal];
            } else if (order.orderState == WZOrderStateRefunding) {
                [cell.mainButton setTitle:@"正在退款" forState:UIControlStateNormal];
            }
            cell.mainButton.tag = indexPath.section;
            [cell.mainButton addTarget:self action:@selector(pressesOrderActionButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WZOrderDetailTableViewController *orderDetailVC = [[WZOrderDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    orderDetailVC.order = self.orders[indexPath.section];
    orderDetailVC.delegate = self;
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - WZOrderDetailTableViewControllerDelegate

- (void)orderDetailTableViewControllerDidUpdateOrderState:(WZOrderDetailTableViewController *)orderDetailVC {
    [self loadOrderListData];
}

#pragma mark - WZPayTableViewControllerDelegate

- (void)payTableViewController:(WZPayTableViewController *)payVC didFinishPaySuccess:(BOOL)success userInfo:(NSString *)userInfo {
    if (success) {
        [self loadOrderListData];
    }
}

#pragma mark - Methods

- (void)loadOrderListData {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.label.text = @"正在加载";
    progressHUD.contentColor = [UIColor whiteColor];
    progressHUD.bezelView.backgroundColor = [UIColor blackColor];
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.offset = CGPointMake(0, -100);
    [WZOrder loadOrderListWithOrderState:self.orderState success:^(NSMutableArray * _Nonnull orders) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [progressHUD hideAnimated:YES];
            self.orders = orders;
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

- (void)wipeOrderListData {
    [self.orders removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - EventHandlers

- (void)pressesOrderActionButton:(UIButton *)button {
    WZOrder *order = self.orders[button.tag];
    if ([button.titleLabel.text isEqualToString:@"立即支付"]) {
        WZPayTableViewController *payVC = [[WZPayTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        payVC.order = order;
        payVC.delegate = self;
        payVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payVC animated:YES];
    } else if ([button.titleLabel.text isEqualToString:@"取消订单"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要取消订单吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [WZOrder cancelOrder:order.orderId success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadOrderListData];
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
        certificationVC.certificationNumber = order.certificationNumber;
        certificationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:certificationVC animated:YES];
    } else if ([button.titleLabel.text isEqualToString:@"申请退款"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要申请退款吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [WZOrder refundOrder:order.orderId success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadOrderListData];
                });
            } failure:^(NSString * _Nonnull userInfo) {
                NSLog(@"%@", userInfo);
            }];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([button.titleLabel.text isEqualToString:@"立即评价"]) {
        
    } else if ([button.titleLabel.text isEqualToString:@"删除订单"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要永久删除订单吗？" message:@"删除后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [WZOrder deleteOrder:order.orderId success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadOrderListData];
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
