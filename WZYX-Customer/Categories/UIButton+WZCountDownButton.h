//
//  UIButton+WZCountDownButton.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/23.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WZCountDownButton)

- (void)countDownWithDuration:(NSInteger)duration interval:(NSInteger)interval countDownTitle:(NSString *)countDownTitle canInteraction:(BOOL)flag finishedBlock:(void (^)(void))finishedBlock;

@end
