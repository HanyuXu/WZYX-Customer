//
//  WZActivitySearchingTableViewController.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/25.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZActivitySearchingTableViewController.h"
#import "WZActivity.h"
#import "WZActivityManager.h"
#import "WZActivityTableViewCell.h"
#import <Masonry.h>

@interface WZActivitySearchingTableViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property(nonatomic, strong) NSMutableArray<WZActivity*> *result;
@end

@implementation WZActivitySearchingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    
    
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchBar);
        make.left.equalTo(self.view).offset(5);
    }];
    //弹出键盘
    self.view.backgroundColor = [UIColor whiteColor];
    [self.searchBar becomeFirstResponder];
}


#pragma mark - searchbar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *str = searchBar.text;
    [searchBar resignFirstResponder];
    if (str) {
        [WZActivityManager searchActivityNearBy:str
                                        success:^(NSMutableArray<WZActivity *>* _Nonnull activities) {
            [self.view addSubview:self.tableView];
        } failure:^{
            [self layoutNoResultLabel];
        }];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self.noResultLabel removeFromSuperview];
    }
}
#pragma mark -  back button
- (void) backToMain {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}


- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - layout
- (void)layoutNoResultLabel {
    [self.view addSubview:self.noResultLabel];
    [self.noResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
}
#pragma mark - tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.result.count;
    return 10;
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WZActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}




#pragma mark - lazy load
- (UISearchBar *)searchBar {
    if (!_searchBar) {
         CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(30, statusRect.size.height, self.view.bounds.size.width-35, 44)];
        _searchBar.delegate = self;
        UITextField *searchField=[_searchBar valueForKey:@"searchField"];
        searchField.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:0.3];
        [_searchBar setBackgroundImage:[UIImage new]];
        [_searchBar setTranslucent:YES];
        for (UIView *view in _searchBar.subviews) {
            if ([view isKindOfClass:UITextField.class]) {
                UITextField *textField = (UITextField *)view;
                textField.delegate = self;
            }
        }
    }
    return _searchBar;
}

- (UIButton *)backButton {
    if (!_backButton) {
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        CGRect frame = CGRectMake(0, statusRect.size.height+10, 25, 25);
        _backButton = [[UIButton alloc] initWithFrame:frame];
        //_backButton.backgroundColor = [UIColor redColor];
        UIImage *image = [UIImage imageNamed:@"back"];
        [_backButton setBackgroundImage:image forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;  
}
-(UILabel *)noResultLabel {
    if (!_noResultLabel) {
        _noResultLabel = [[UILabel alloc] init];
        _noResultLabel.text = @"未搜索到相关活动";
        _noResultLabel.textColor = [UIColor lightGrayColor];
    }
    return _noResultLabel;
}

-(NSMutableArray<WZActivity*> *)result {
    if( !_result ){
        _result = [[NSMutableArray alloc] init];
    }
    return _result;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.size.height + 20, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height - 20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}
@end
