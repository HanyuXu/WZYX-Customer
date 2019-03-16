//
//  WZActivityBaseTableView.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/12/12.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZActivityBaseTableView.h"

@implementation WZActivityBaseTableView
/**
同时识别多个手势

@param gestureRecognizer gestureRecognizer description
@param otherGestureRecognizer otherGestureRecognizer description
@return return value description
*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
