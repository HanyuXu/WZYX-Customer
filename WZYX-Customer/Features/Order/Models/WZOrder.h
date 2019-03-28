//
//  WZOrder.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/30.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WZOrderState) {
    WZOrderStateWaitingPayment          =   0,  // 待付款
    WZOrderStateWaitingParticipation    =   1,  // 待参与
    WZOrderStateWaitingComment          =   2,  // 待评价
    WZOrderStateOverdue                 =   3,  // 已过期
    WZOrderStateCanceled                =   4,  // 已取消
    WZOrderStateRefunding               =   5,  // 退款中
    WZOrderStateRefunded                =   6,  // 已退款
    WZOrderStateFinished                =   7,  // 已完成
    WZOrderStateAllState                =   99, // 所有状态
};

typedef NS_ENUM(NSUInteger, WZOrderPaymentMethod) {
    WZOrderPaymentMethodNone            =   0,  // 未支付
    WZOrderPaymentMethodAlipay          =   1,  // 支付宝
    WZOrderPaymentMethodWeChatPay       =   2,  // 微信支付
    WZOrderPaymentMethodUnionPay        =   3,  // 银联支付
};

@interface WZOrder : NSObject <NSCoding>

@property (copy, nonatomic) NSString *orderId;                      // 订单ID
@property (copy, nonatomic) NSString *orderTimeStamp;               // 订单时间戳
@property (assign, nonatomic) WZOrderState orderState;              // 订单状态

@property (copy, nonatomic) NSString *sponsorId;                    // 主办方ID
@property (copy, nonatomic) NSString *sponsorName;                  // 主办方名称

@property (copy, nonatomic) NSString *eventId;                      // 活动ID
@property (copy, nonatomic) NSString *eventAvatar;                  // 活动图片
@property (copy, nonatomic) NSString *eventTitle;                   // 活动标题
@property (copy, nonatomic) NSString *eventSeason;                  // 活动场次
@property (copy, nonatomic) NSString *eventPrice;                   // 活动单价

@property (copy, nonatomic) NSString *purchaseCount;                // 购买数量
@property (copy, nonatomic) NSString *orderAmount;                  // 订单总价
@property (copy, nonatomic) NSString *orderDiscount;                // 订单优惠
@property (copy, nonatomic) NSString *actualAmount;                 // 实际支付

@property (assign, nonatomic) WZOrderPaymentMethod paymentMethod;   // 支付手段
@property (copy, nonatomic) NSString *paymentTimeStamp;             // 支付时间戳

@property (copy, nonatomic) NSString *certificationNumber;          // 凭证
@property (copy, nonatomic) NSString *myCommentId;                  // 我的评价ID

- (instancetype)initWithDataDictionary:(NSDictionary *)dataDictionary;

+ (void)loadOrderListWithOrderState:(WZOrderState)orderState offset:(NSUInteger)offset limit:(NSUInteger)limit success:(void (^)(NSMutableArray *orders))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)loadOrder:(NSString *)orderId success:(void (^)(WZOrder *order))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)payOrder:(NSString *)orderId withPaymentMethod:(WZOrderPaymentMethod)method success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)cancelOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)refundOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)deleteOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)commentOrder:(NSString *)orderId withCommentText:(NSString *)commentText commentlevel:(NSInteger)commentLevel success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

+ (void)createOrderWithEventId:(NSString *)eventId eventSeason:(NSString *)eventSeason purchaseCount:(NSUInteger)purchaseCount success:(void (^)(WZOrder *order))successBlock failure:(void (^)(NSString *userInfo))failureBlock;

// 仅测试用
//+ (void)prepareTestData;
//+ (void)addTestData;
//+ (void)dropTestData;

@end

NS_ASSUME_NONNULL_END
