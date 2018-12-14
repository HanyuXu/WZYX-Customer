//
//  WZOrderActionTableViewCell.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/10.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWZOrderActionTableViewCellOneAction           @"kWZOrderActionTableViewCellOneAction"
#define kWZOrderActionTableViewCellTwoAction           @"kWZOrderActionTableViewCellTwoAction"

NS_ASSUME_NONNULL_BEGIN

@interface WZOrderActionTableViewCell : UITableViewCell

@property (strong, nonatomic) UIButton *mainButton;
@property (strong, nonatomic) UIButton *anotherButton;

@end

NS_ASSUME_NONNULL_END
