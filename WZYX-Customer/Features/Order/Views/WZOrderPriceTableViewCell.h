//
//  WZOrderPriceTableViewCell.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/10.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZOrderPriceTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *totalPriceLabel;
@property (strong, nonatomic) UILabel *discountLabel;
@property (strong, nonatomic) UILabel *actualPaymentLabel;

@end

NS_ASSUME_NONNULL_END
