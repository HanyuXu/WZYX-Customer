//
//  WZStarLevelTableViewCell.h
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/8.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WZStarLevelTableViewCell;

@protocol WZStarLevelTableViewCellDelegate <NSObject>

- (void)starLevelTableViewCell:(WZStarLevelTableViewCell *)cell didGetNewStarLevel:(NSUInteger)starLevel;

@end

@interface WZStarLevelTableViewCell : UITableViewCell

@property (weak, nonatomic) id<WZStarLevelTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
