//
//  WZBaseScrollViewController.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/30.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZBaseScrollViewController.h"
#import "WZOrderListTableViewController.h"
#import "WZOrder.h"

#import "Masonry.h"

#define kWZScreenWidth              [UIScreen mainScreen].bounds.size.width
#define kWZScreenHeight             [UIScreen mainScreen].bounds.size.height
#define kWZStatusBarHeight          [[UIApplication sharedApplication] statusBarFrame].size.height
#define kWZNavigationBarHeight      self.navigationController.navigationBar.frame.size.height
#define kWZTitleViewHeight          35

@interface WZBaseScrollViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *underlineView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableArray *titleButtons;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation WZBaseScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kWZStatusBarHeight + kWZNavigationBarHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kWZTitleViewHeight);
    }];
    [self setupTitleButtons];
    [self setupChildViewControllers];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    self.scrollView.contentSize = CGSizeMake(kWZScreenWidth * self.childViewControllers.count, 0);
    
    self.selectedIndex = -1;
    [self pressesTitleButton:self.titleButtons[0]];
    
//    UIBarButtonItem *testPrepareDataButton = [[UIBarButtonItem alloc] initWithTitle:@"初始化" style:UIBarButtonItemStylePlain target:self action:@selector(pressesTestPrepareDataButton:)];
//    UIBarButtonItem *testAddOrderButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(pressesTestAddOrderButton:)];
//    UIBarButtonItem *testDropDataButton = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(pressesTestDropDataButton:)];
//    self.navigationItem.leftBarButtonItems = @[testPrepareDataButton, testAddOrderButton, testDropDataButton];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger selectedIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIButton *selectedButton = self.titleButtons[selectedIndex];
    [self pressesTitleButton:selectedButton];
}

#pragma mark - PrivateMethod

- (void)setupChildViewControllers {
    [self addChildViewController:[[WZOrderListTableViewController alloc] initWithStyle:UITableViewStyleGrouped orderState:WZOrderStateAllState]];
    [self addChildViewController:[[WZOrderListTableViewController alloc] initWithStyle:UITableViewStyleGrouped orderState:WZOrderStateWaitingPayment]];
    [self addChildViewController:[[WZOrderListTableViewController alloc] initWithStyle:UITableViewStyleGrouped orderState:WZOrderStateWaitingParticipation]];
    [self addChildViewController:[[WZOrderListTableViewController alloc] initWithStyle:UITableViewStyleGrouped orderState:WZOrderStateWaitingComment]];
    [self addChildViewController:[[WZOrderListTableViewController alloc] initWithStyle:UITableViewStyleGrouped orderState:WZOrderStateFinished]];
}

- (void)setupTitleButtons {
    NSArray *titles = @[@"全部", @"待付款", @"待参与", @"待评价", @"已完成"];
    CGFloat buttonWidth = kWZScreenWidth / titles.count;
    for (NSUInteger i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [self.titleView addSubview:button];
        [self.titleButtons addObject:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.titleView);
            make.width.equalTo(@(kWZScreenWidth / titles.count));
            make.left.equalTo(self.titleView).offset(buttonWidth * i);
        }];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(pressesTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - EventHandlers

//- (void)pressesTestPrepareDataButton:(UIBarButtonItem *)barButton {
//    [WZOrder prepareTestData];
//    WZOrderListTableViewController *orderListVC = self.childViewControllers[self.selectedIndex];
//    [orderListVC loadOrderListData];
//}
//
//- (void)pressesTestAddOrderButton:(UIBarButtonItem *)barButton {
//    [WZOrder addTestData];
//    WZOrderListTableViewController *orderListVC = self.childViewControllers[self.selectedIndex];
//    [orderListVC loadOrderListData];
//}
//
//- (void)pressesTestDropDataButton:(UIBarButtonItem *)barButton {
//    [WZOrder dropTestData];
//    WZOrderListTableViewController *orderListVC = self.childViewControllers[self.selectedIndex];
//    [orderListVC loadOrderListData];
//}

- (void)pressesTitleButton:(UIButton *)button {
    if (button.tag != self.selectedIndex) {
        BOOL animate = YES;
        if (self.selectedIndex == -1) {
            animate = NO;
            [self.titleView addSubview:self.underlineView];
            [self.underlineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.titleView).offset(0);
                make.height.equalTo(@2);
                make.centerX.equalTo(button.titleLabel);
                make.width.equalTo(button.titleLabel);
            }];
        } else {
            UIButton *preSelectedButton = self.titleButtons[self.selectedIndex];
            preSelectedButton.selected = NO;
            WZOrderListTableViewController *preOrderListVC = self.childViewControllers[self.selectedIndex];
            [preOrderListVC wipeOrderListData];
            [self.underlineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.titleView).offset(0);
                make.height.equalTo(@2);
                make.centerX.equalTo(button.titleLabel);
                make.width.equalTo(button.titleLabel);
            }];
        }
        
        button.selected = YES;
        self.selectedIndex = button.tag;
        
        CGFloat offsetX = kWZScreenWidth * button.tag;
        WZOrderListTableViewController *orderListVC = self.childViewControllers[button.tag];
        UIView *subView = orderListVC.view;
        subView.frame = CGRectMake(offsetX, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:subView];
        
        if (animate) {
            [UIView animateWithDuration:0.25 animations:^{
                self.scrollView.contentOffset = CGPointMake(offsetX, 0);
                [self.view layoutIfNeeded];
            } completion:nil];
        }
        [orderListVC loadOrderListData];
    }
}

#pragma mark - LazyLoad

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}

- (NSMutableArray *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray arrayWithCapacity:5];
    }
    return _titleButtons;
}

- (UIView *)underlineView {
    if (!_underlineView) {
        _underlineView = [[UIView alloc] init];
        _underlineView.backgroundColor = [UIColor redColor];
    }
    return _underlineView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
