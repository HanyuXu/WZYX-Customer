//
//  WZNoContentView.h
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/7.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WZNoContentViewType) {
    WZNoContentViewTypeNetwork  =   0,  // 无网络
    WZNoContentViewTypeOrder    =   1,  // 无订单
};

@interface WZNoContentView : UIView

@property (assign, nonatomic) WZNoContentViewType type;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setType:(WZNoContentViewType)type;

@end

NS_ASSUME_NONNULL_END
