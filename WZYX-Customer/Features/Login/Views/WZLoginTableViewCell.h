//
//  WZLoginTableViewCell.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/22.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWZLoginTableViewCellForLabel                  @"kWZLoginTableViewCellForLabel"
#define kWZLoginTableViewCellForPhoneNumber            @"kWZLoginTableViewCellForPhoneNumber"
#define kWZLoginTableViewCellForPassword               @"kWZLoginTableViewCellForPassword"
#define kWZLoginTableViewCellForVerification           @"kWZLoginTableViewCellForVerification"
#define kWZLoginTableViewCellForButton                 @"kWZLoginTableViewCellForButton"
#define kWZLoginTableViewCellForSubmitButton           @"kWZLoginTableViewCellForSubmitButton"
#define kWZLoginTableViewCellForLabelAndButton         @"kWZLoginTableViewCellForLabelAndButton"

NS_ASSUME_NONNULL_BEGIN

@interface WZLoginTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIButton *submitButton;

@end

NS_ASSUME_NONNULL_END
