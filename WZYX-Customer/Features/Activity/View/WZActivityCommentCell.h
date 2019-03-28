//
//  WZActivityCommentCell.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/3/28.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WZActivityRankView;
@interface WZActivityCommentCell : UITableViewCell
@property(nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) WZActivityRankView *rankView;
- (void)commentRankLevelWith:(NSInteger) level;
@end

NS_ASSUME_NONNULL_END
