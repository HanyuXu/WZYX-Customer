//
//  WZThirdPayMockViewController.h
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/4.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZOrder.h"

NS_ASSUME_NONNULL_BEGIN

@class WZThirdPayMockViewController;

@protocol WZThirdPayMockViewControllerDelegate <NSObject>

- (void)thirdPayMock:(WZThirdPayMockViewController *)thirdPayMock didFinishPaySuccess:(BOOL)success userInfo:(NSString * _Nullable)userInfo;

@end

@interface WZThirdPayMockViewController : UIViewController

@property (strong, nonatomic) WZOrder *order;
@property (weak, nonatomic) id<WZThirdPayMockViewControllerDelegate> delegate;

+ (instancetype)thirdPayMockWithPaymentMethod:(WZOrderPaymentMethod)method;

@end

NS_ASSUME_NONNULL_END
