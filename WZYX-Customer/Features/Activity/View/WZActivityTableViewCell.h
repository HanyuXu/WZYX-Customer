//
//  WZActivityTableViewCell.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/14.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZActivityTableViewCell : UITableViewCell
@property(strong, nonatomic) UIImageView *activityImageView;
@property(strong, nonatomic) UILabel *activityNameLabel;
@property(strong, nonatomic) UILabel *activityDateLabel;
@property(strong, nonatomic) UILabel *activityPirceLabel;
@property(strong, nonatomic) UILabel *activityLocationLabel;

@end

NS_ASSUME_NONNULL_END
