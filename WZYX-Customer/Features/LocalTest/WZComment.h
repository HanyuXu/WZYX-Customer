//
//  WZComment.h
//  WZYX-Customer
//
//  Created by 祈越 on 2019/3/28.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZComment : NSObject

@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *commenter;
@property (strong, nonatomic) NSString *commentText;
@property (assign, nonatomic) NSInteger commentLevel;
@property (strong, nonatomic) NSString *commentDate;

+ (void)commentEvent:(NSString *)eventId withCommenter:(NSString *)commenter commentText:(NSString *)commentText commentlevel:(NSInteger)commentLevel success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)downloadCommentForEvent:(NSString *)eventId success:(void (^)(NSArray *comments))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

@end

NS_ASSUME_NONNULL_END
