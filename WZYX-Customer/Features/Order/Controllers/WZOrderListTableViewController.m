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
#import "WZNoContentView.h"
#import "WZCommentTableViewController.h"

#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface WZOrderListTableViewController () <WZOrderDetailTableViewControllerDelegate, WZPayTableViewControllerDelegate, WZCommentTableViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *orders;

@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) WZNoContentView *noContentView;

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
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullDownRefreshOrderListData];
    }];
    [normalHeader setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [normalHeader setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [normalHeader setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    normalHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = normalHeader;
    MJRefreshBackNormalFooter *normalFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreOrderListDataFromOffset:self.orders.count];
    }];
    [normalFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [normalFooter setTitle:@"松开立即加载" forState:MJRefreshStatePulling];
    [normalFooter setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [normalFooter setTitle:@"已加载所有订单" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = normalFooter;
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
        NSArray *states = @[@"待付款", @"待参与", @"待评价", @"已过期", @"已取消", @"退款中", @"已退款", @"已完成", @"所有状态"];
        cell.orderStateLabel.text = states[order.orderState];
        cell.eventAvatarImageView.image = [UIImage imageNamed:order.eventAvatar];
        cell.eventTitleLabel.text = order.eventTitle;
        cell.priceAndCountLabel.text = [NSString stringWithFormat:@"¥ %@\nx %@", order.eventPrice, order.purchaseCount];
        cell.eventSeasonLabel.text = order.eventSeason;
        cell.orderAmountLabel.text = [NSString stringWithFormat:@"实付款：¥ %@", order.actualAmount];
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

#pragma mark - WZCommentTableViewControllerDelegate

- (void)commentTableViewController:(WZCommentTableViewController *)commentVC didFinishCommentSuccess:(BOOL)success userInfo:(NSString *)userInfo {
    if (success) {
        [self loadOrderListData];
    }
}

#pragma mark - Methods

- (void)loadOrderListData {
    [self.noContentView removeFromSuperview];
    self.noContentView = nil;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD showAnimated:YES];
    [WZOrder loadOrderListWithOrderState:self.orderState offset:0 limit:(self.orders.count < 5 ? 5 : self.orders.count) success:^(NSMutableArray * _Nonnull orders) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressHUD hideAnimated:YES];
            [self.tableView.mj_footer resetNoMoreData];
            self.orders = orders;
            [self.tableView reloadData];
            if (self.orders.count == 0) {
                [self showNoContentViewWithType:WZNoContentViewTypeOrder];
            }
        });
    } failure:^(NSString * _Nonnull userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressHUD hideAnimated:YES];
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
    if (self.noContentView) {
        [self.noContentView removeFromSuperview];
        self.noContentView = nil;
    }
}

#pragma mark - PrivateMethods

- (void)pullDownRefreshOrderListData {
    [WZOrder loadOrderListWithOrderState:self.orderState offset:0 limit:5 success:^(NSMutableArray * _Nonnull orders) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
            self.orders = orders;
            [self.tableView reloadData];
            if (self.orders.count != 0) {
                [self.noContentView removeFromSuperview];
                self.noContentView = nil;
            }
        });
    } failure:^(NSString * _Nonnull userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}

- (void)loadMoreOrderListDataFromOffset:(NSUInteger)offset {
    [WZOrder loadOrderListWithOrderState:self.orderState offset:offset limit:5 success:^(NSMutableArray * _Nonnull orders) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (orders.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
                [self.orders addObjectsFromArray:orders];
                [self.tableView reloadData];
            }
            if (self.orders.count != 0) {
                [self.noContentView removeFromSuperview];
                self.noContentView = nil;
            }
        });
    } failure:^(NSString * _Nonnull userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}

- (void)showNoContentViewWithType:(WZNoContentViewType)type {
    self.noContentView = [[WZNoContentView alloc] initWithFrame:self.view.bounds];
    self.noContentView.type = type;
    [self.view addSubview:self.noContentView];
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
        WZCommentTableViewController *commentVC = [[WZCommentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        commentVC.order = order;
        commentVC.delegate = self;
        commentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentVC animated:YES];
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

#pragma mark - LazyLoad

- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _progressHUD.label.text = @"正在加载";
        _progressHUD.contentColor = [UIColor whiteColor];
        _progressHUD.bezelView.backgroundColor = [UIColor blackColor];
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.offset = CGPointMake(0, -100);
    }
    return _progressHUD;
}

@end
