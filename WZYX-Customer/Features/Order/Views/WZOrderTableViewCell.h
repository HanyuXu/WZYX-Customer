//
//  WZOrderTableViewCell.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/30.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZOrderTableViewCell : UITableViewCell

@property (strong, nonatomic) UIButton *sponsorNameButton;
@property (strong, nonatomic) UILabel *orderStateLabel;
@property (strong, nonatomic) UIImageView *eventAvatarImageView;
@property (strong, nonatomic) UILabel *eventTitleLabel;
@property (strong, nonatomic) UILabel *priceAndCountLabel;
@property (strong, nonatomic) UILabel *eventSeasonLabel;
@property (strong, nonatomic) UILabel *orderAmountLabel;

@end

NS_ASSUME_NONNULL_END
