//
//  UIButton+WZCountDownButton.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/23.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "UIButton+WZCountDownButton.h"

@implementation UIButton (WZCountDownButton)

- (void)countDownWithDuration:(NSInteger)duration interval:(NSInteger)interval countDownTitle:(NSString *)countDownTitle canInteraction:(BOOL)flag finishedBlock:(void (^)(void))finishedBlock {
    self.enabled = flag;
    __block NSInteger remaining = duration;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (remaining == 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                finishedBlock();
            });
        } else {
            NSInteger countDownSecond = remaining;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:[NSString stringWithFormat:@"%ld%@", countDownSecond, countDownTitle] forState:UIControlStateNormal];
            });
            remaining -= interval;
        }
    });
    dispatch_resume(timer);
}

@end
