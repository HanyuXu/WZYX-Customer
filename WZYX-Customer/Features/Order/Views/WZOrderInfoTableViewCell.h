//
//  WZOrderInfoTableViewCell.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/10.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZOrderInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *orderIdLabel;
@property (strong, nonatomic) UILabel *orderTimeStampLabel;
@property (strong, nonatomic) UILabel *paymentMethodLabel;
@property (strong, nonatomic) UILabel *paymentTimeStampLabel;

@end

NS_ASSUME_NONNULL_END
