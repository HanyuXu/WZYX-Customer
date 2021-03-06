//
//  WZUserPortraitTableViewCell.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/26.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWZUserPortraitTableViewCellLeft    @"kWZUserPortraitTableViewCellLeft"
#define kWZUserPortraitTableViewCellRight   @"kWZUserPortraitTableViewCellRight"

NS_ASSUME_NONNULL_BEGIN

@interface WZUserPortraitTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *userNameLabel;

@end

NS_ASSUME_NONNULL_END
