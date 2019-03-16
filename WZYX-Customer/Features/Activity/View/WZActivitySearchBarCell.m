//
//  WZActivitySearchBarCell.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/12.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#define kWZActivitySearchBarCellEdgeInsets UIEdgeInsetsMake(5,5,1,1)

#import "WZActivitySearchBarCell.h"
#import <Masonry.h>

@implementation WZActivitySearchBarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.searchBar];
    }
    return self;
}

- (void)layoutSubviews {
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(kWZActivitySearchBarCellEdgeInsets);
    }];
}
#pragma  mark - lazy load
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 42)];
        UITextField *searchField=[_searchBar valueForKey:@"searchField"];
        searchField.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:0.3];
        [_searchBar setBackgroundImage:[UIImage new]];
        [_searchBar setTranslucent:YES];
        _searchBar.placeholder = @"请输入商品名称";
    }
    return _searchBar;
}

@end
