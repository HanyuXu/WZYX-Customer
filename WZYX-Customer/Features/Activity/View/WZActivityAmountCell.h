//
//  WZActivityAmountCell.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/3/24.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol WZActivityAmountButtonDelegate <NSObject>
@optional
- (void)addActivityAmount;
- (void)subActivityAmount;
@end
@interface WZActivityAmountCell : UITableViewCell
@property(nonatomic, assign) NSUInteger amount;
@property(nonatomic, weak) id<WZActivityAmountButtonDelegate> delegate;
@property(nonatomic, assign) NSUInteger threshold;
- (void)add;
- (void)sub;
@end

NS_ASSUME_NONNULL_END
