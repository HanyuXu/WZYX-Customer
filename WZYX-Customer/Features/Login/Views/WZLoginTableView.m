//
//  WZLoginTableView.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/22.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZLoginTableView.h"

@implementation WZLoginTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.1)];
        self.tableHeaderView = headerView;
        self.rowHeight = UITableViewAutomaticDimension;
        self.estimatedRowHeight = 44;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return self;
}

@end
