//
//  WZOrder.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/11/30.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZOrder.h"
#import "WZObjectDictionaryConverter.h"
#import "WZDateStringConverter.h"
#import "WZRandomStringGenerator.h"
#import "WZHTTPSessionManager.h"
#import "WZUserInfoManager.h"
#import "FMDatabase.h"
#import "WZRandomStringGenerator.h"
#import "WZComment.h"
#import "WZUser.h"

#define SANDBOX_DOCUMENT_PATH       NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define SANDBOX_CACHES_PATH         NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
#define DEFAULT_FILE_MANAGER        [NSFileManager defaultManager]

@implementation WZOrder

//- (instancetype)initWithDataDictionary:(NSDictionary *)dataDictionary {
//    if (self = [super init]) {
//        NSArray *properties = [WZObjectDictionaryConverter propertiesArrayOfClass:[self class]];
//        for (NSString *property in properties) {
//            if (dataDictionary[property] && dataDictionary[property] != [NSNull null]) {
//                [self setValue:dataDictionary[property] forKey:property];
//            }
//        }
//    }
//    return self;
//}

- (instancetype)initWithDataDictionary:(NSDictionary *)dataDictionary {
    if (self = [super init]) {
        self.orderId = [NSString stringWithFormat:@"%@", dataDictionary[@"o_id"]];
        self.orderTimeStamp = dataDictionary[@"o_createtime"];
        self.orderState = [dataDictionary[@"o_state"] unsignedIntegerValue];
        self.sponsorId = dataDictionary[@"shop_name"];
        self.sponsorName = dataDictionary[@"shop_name"];
        self.eventId = [NSString stringWithFormat:@"%@", dataDictionary[@"p_id"]];
        self.eventAvatar = dataDictionary[@"image"];
        self.eventTitle = dataDictionary[@"product_name"];
        self.eventSeason = [NSString stringWithFormat:@"%@\n%@", dataDictionary[@"product_location"], dataDictionary[@"product_starttime"]];
        self.eventPrice = dataDictionary[@"price"];
        self.purchaseCount = dataDictionary[@"s_number"];
        self.orderAmount = dataDictionary[@"totalprice"];
        self.orderDiscount = @"0.00";
        self.actualAmount = dataDictionary[@"totalprice"];
        self.paymentMethod = [dataDictionary[@"o_payway"] integerValue];
        self.paymentTimeStamp = dataDictionary[@"o_paytime"];
        self.certificationNumber = [WZRandomStringGenerator randomStringFromSourceString:@"0123456789" length:16];
        self.myCommentId = @"";
    }
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        NSArray *properties = [WZObjectDictionaryConverter propertiesArrayOfClass:[self class]];
        for (NSString *property in properties) {
            [self setValue:[aDecoder decodeObjectForKey:property] forKey:property];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSArray *properties = [WZObjectDictionaryConverter propertiesArrayOfClass:[self class]];
    for (NSString *property in properties) {
        [aCoder encodeObject:[self valueForKey:property] forKey:property];
    }
}

#pragma mark - Methods

+ (void)createOrderWithEventId:(NSString *)eventId eventSeason:(NSString *)eventSeason purchaseCount:(NSUInteger)purchaseCount success:(void (^)(WZOrder *order))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [WZHTTPSessionManager sharedManager];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
    NSDictionary *paramsDictionary = @{@"authToken" : authToken,
                                       @"eventId" : eventId,
                                       @"eventSeason" : eventSeason,
                                       @"purchaseCount" : [NSNumber numberWithUnsignedInteger:purchaseCount]};
    [manager POST:@"http://120.79.10.184:8080/order/gen_order" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            NSDictionary *dataDictionary = responseDictionary[@"data"];
            WZOrder *order = [[WZOrder alloc] initWithDataDictionary:dataDictionary];
            [NSThread sleepForTimeInterval:0.5];
            successBlock(order);
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)loadOrderListWithOrderState:(WZOrderState)orderState offset:(NSUInteger)offset limit:(NSUInteger)limit success:(void (^)(NSMutableArray *orders))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    if (![WZUserInfoManager userIsLoggedIn]) {
        failureBlock(@"用户未登录");
        return;
    }
    AFHTTPSessionManager *manager = [WZHTTPSessionManager sharedManager];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
    NSDictionary *paramsDictionary;
    if (orderState == WZOrderStateAllState) {
        paramsDictionary = @{@"authToken" : authToken,
                             @"pageNumber" : [NSNumber numberWithUnsignedInteger:offset],
                             @"pageSize" : [NSNumber numberWithUnsignedInteger:limit]};
    } else {
        paramsDictionary = @{@"authToken" : authToken,
                             @"oState" : [NSNumber numberWithUnsignedInteger:orderState],
                             @"pageNumber" : [NSNumber numberWithUnsignedInteger:offset],
                             @"pageSize" : [NSNumber numberWithUnsignedInteger:limit]};
    }
    [manager POST:@"http://120.79.10.184:8080/order/scan_order" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            NSDictionary *dataDictionary = responseDictionary[@"data"];
            NSArray *dataArray = dataDictionary[@"list"];
            NSMutableArray *orders = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dic in dataArray) {
                WZOrder *order = [[WZOrder alloc] initWithDataDictionary:dic];
                [orders addObject:order];
            }
            [NSThread sleepForTimeInterval:0.5];
            successBlock(orders);
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)loadOrder:(NSString *)orderId success:(void (^)(WZOrder *order))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [WZHTTPSessionManager sharedManager];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
    NSDictionary *paramsDictionary = @{@"authToken" : authToken,
                                       @"oId" : orderId};
    [manager POST:@"http://120.79.10.184:8080/order/order_detailed" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            NSDictionary *dataDictionary = responseDictionary[@"data"];
            WZOrder *order = [[WZOrder alloc] initWithDataDictionary:dataDictionary];
            [NSThread sleepForTimeInterval:0.5];
            successBlock(order);
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)payOrder:(NSString *)orderId withPaymentMethod:(WZOrderPaymentMethod)method success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [WZHTTPSessionManager sharedManager];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
    NSDictionary *paramsDictionary = @{@"authToken" : authToken,
                                       @"orderId" : orderId,
                                       @"paymentMethod" : [NSNumber numberWithUnsignedInteger:method]};
    [manager POST:@"http://120.79.10.184:8080/order/pay_order_fake" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            [NSThread sleepForTimeInterval:0.5];
            successBlock();
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)cancelOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [WZHTTPSessionManager sharedManager];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
    NSDictionary *paramsDictionary = @{@"authToken" : authToken, @"oId" : orderId};
    [manager POST:@"http://120.79.10.184:8080/order/cancel_order" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            [NSThread sleepForTimeInterval:0.5];
            successBlock();
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)refundOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [WZHTTPSessionManager sharedManager];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
    NSDictionary *paramsDictionary = @{@"authToken" : authToken,
                                       @"orderId" : orderId};
    [manager POST:@"http://120.79.10.184:8080/order/refound_order" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            [NSThread sleepForTimeInterval:0.5];
            successBlock();
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)deleteOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [WZHTTPSessionManager sharedManager];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
    NSDictionary *paramsDictionary = @{@"authToken" : authToken, @"oId" : orderId};
    [manager POST:@"http://120.79.10.184:8080/order/delete_order" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            [NSThread sleepForTimeInterval:0.5];
            successBlock();
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

+ (void)commentOrder:(WZOrder *)order withCommentText:(NSString *)commentText commentlevel:(NSInteger)commentLevel success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    AFHTTPSessionManager *manager = [WZHTTPSessionManager sharedManager];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
    NSDictionary *paramsDictionary = @{@"authToken" : authToken,
                                       @"oId" : order.orderId,
                                       @"status" : [NSNumber numberWithUnsignedInteger:WZOrderStateFinished]};
    [manager POST:@"http://120.79.10.184:8080/order/set_order_status" parameters:paramsDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([responseDictionary[@"status"] intValue] == 0) {
            if ([WZUserInfoManager userIsLoggedIn]) {
                [WZUserInfoManager loadUserInfo];
            }
            [WZComment commentEvent:order.eventId withCommenter:[WZUser sharedUser].userName commentText:commentText commentlevel:commentLevel success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSThread sleepForTimeInterval:0.5];
                    successBlock();
                });
            } failure:^(NSString * _Nonnull userInfo) {
                failureBlock(userInfo);
            }];
        } else {
            failureBlock(responseDictionary[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(@"服务器未响应，请稍后重试");
    }];
}

#pragma mark - Test

//+ (void)loadOrderListWithOrderState:(WZOrderState)orderState offset:(NSUInteger)offset limit:(NSUInteger)limit success:(void (^)(NSMutableArray *orders))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:0.5];
//        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
//        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//        if (![db open]) {
//            failureBlock(@"数据库打开失败");
//            return;
//        }
//        FMResultSet *results;
//        if (orderState == WZOrderStateAllState) {
//            results = [db executeQuery:@"SELECT * FROM test_order ORDER BY orderId DESC LIMIT ? OFFSET ?" withArgumentsInArray:@[[NSNumber numberWithUnsignedInteger:limit], [NSNumber numberWithUnsignedInteger:offset]]];
//        } else {
//            results = [db executeQuery:@"SELECT * FROM test_order WHERE orderState = ? ORDER BY orderId DESC LIMIT ? OFFSET ?" withArgumentsInArray:@[[NSNumber numberWithUnsignedInteger:orderState], [NSNumber numberWithUnsignedInteger:limit], [NSNumber numberWithUnsignedInteger:offset]]];
//        }
//        NSMutableArray *orders = [NSMutableArray arrayWithCapacity:limit];
//        while ([results next]) {
//            NSData *orderInfo = [results objectForColumn:@"orderInfo"];
//            WZOrder *order = [NSKeyedUnarchiver unarchiveObjectWithData:orderInfo];
//            [orders addObject:order];
//        }
//        [db close];
//        successBlock(orders);
//    });
//}
//
//+ (void)loadOrder:(NSString *)orderId success:(void (^)(WZOrder *order))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:0.5];
//        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
//        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//        if (![db open]) {
//            failureBlock(@"数据库打开失败");
//            return;
//        }
//        FMResultSet *results;
//        results = [db executeQuery:@"SELECT * FROM test_order WHERE orderId = ?" withArgumentsInArray:@[orderId]];
//        if ([results next]) {
//            NSData *orderInfo = [results objectForColumn:@"orderInfo"];
//            WZOrder *order = [NSKeyedUnarchiver unarchiveObjectWithData:orderInfo];
//            successBlock(order);
//        } else {
//            failureBlock(@"未找到订单");
//        }
//        [db close];
//    });
//}
//
//+ (void)payOrder:(NSString *)orderId withPaymentMethod:(WZOrderPaymentMethod)method success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
//        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//        if (![db open]) {
//            failureBlock(@"数据库打开失败");
//            return;
//        }
//        FMResultSet *results;
//        results = [db executeQuery:@"SELECT * FROM test_order WHERE orderId = ?" withArgumentsInArray:@[orderId]];
//        if ([results next]) {
//            NSData *orderInfo = [results objectForColumn:@"orderInfo"];
//            WZOrder *order = [NSKeyedUnarchiver unarchiveObjectWithData:orderInfo];
//            order.orderState = WZOrderStateWaitingParticipation;
//            order.paymentMethod = method;
//            order.paymentTimeStamp = [WZDateStringConverter stringFromDate:[NSDate date]];
//            order.certificationNumber = [WZRandomStringGenerator randomStringFromSourceString:@"0123456789" length:16];
//            orderInfo = [NSKeyedArchiver archivedDataWithRootObject:order];
//            if ([db executeUpdate:@"UPDATE test_order SET orderState = ?, orderInfo = ? WHERE orderId = ?" withArgumentsInArray:@[[NSNumber numberWithUnsignedInteger:order.orderState], orderInfo, order.orderId]]) {
//                successBlock();
//            } else {
//                failureBlock(@"支付失败");
//            }
//        } else {
//            failureBlock(@"未找到订单");
//        }
//        [db close];
//    });
//}
//
//+ (void)cancelOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
//        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//        if (![db open]) {
//            failureBlock(@"数据库打开失败");
//            return;
//        }
//        FMResultSet *results;
//        results = [db executeQuery:@"SELECT * FROM test_order WHERE orderId = ?" withArgumentsInArray:@[orderId]];
//        if ([results next]) {
//            NSData *orderInfo = [results objectForColumn:@"orderInfo"];
//            WZOrder *order = [NSKeyedUnarchiver unarchiveObjectWithData:orderInfo];
//            order.orderState = WZOrderStateCanceled;
//            orderInfo = [NSKeyedArchiver archivedDataWithRootObject:order];
//            if ([db executeUpdate:@"UPDATE test_order SET orderState = ?, orderInfo = ? WHERE orderId = ?" withArgumentsInArray:@[[NSNumber numberWithUnsignedInteger:order.orderState], orderInfo, order.orderId]]) {
//                successBlock();
//            } else {
//                failureBlock(@"取消订单失败");
//            }
//        } else {
//            failureBlock(@"未找到订单");
//        }
//        [db close];
//    });
//}
//
//+ (void)refundOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
//        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//        if (![db open]) {
//            failureBlock(@"数据库打开失败");
//            return;
//        }
//        FMResultSet *results;
//        results = [db executeQuery:@"SELECT * FROM test_order WHERE orderId = ?" withArgumentsInArray:@[orderId]];
//        if ([results next]) {
//            NSData *orderInfo = [results objectForColumn:@"orderInfo"];
//            WZOrder *order = [NSKeyedUnarchiver unarchiveObjectWithData:orderInfo];
//            order.orderState = WZOrderStateRefunding;
//            orderInfo = [NSKeyedArchiver archivedDataWithRootObject:order];
//            if ([db executeUpdate:@"UPDATE test_order SET orderState = ?, orderInfo = ? WHERE orderId = ?" withArgumentsInArray:@[[NSNumber numberWithUnsignedInteger:order.orderState], orderInfo, order.orderId]]) {
//                successBlock();
//            } else {
//                failureBlock(@"申请退款失败");
//            }
//        } else {
//            failureBlock(@"未找到订单");
//        }
//        [db close];
//    });
//}
//
//+ (void)deleteOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
//        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//        if (![db open]) {
//            failureBlock(@"数据库打开失败");
//            return;
//        }
//        if ([db executeUpdate:@"DELETE FROM test_order WHERE orderId = ?" withArgumentsInArray:@[orderId]]) {
//            successBlock();
//        } else {
//            failureBlock(@"删除订单失败");
//        }
//        [db close];
//    });
//}
//
//+ (void)commentOrder:(NSString *)orderId withCommentText:(NSString *)commentText commentlevel:(NSInteger)commentLevel success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
//        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//        if (![db open]) {
//            failureBlock(@"数据库打开失败");
//            return;
//        }
//        FMResultSet *results;
//        results = [db executeQuery:@"SELECT * FROM test_order WHERE orderId = ?" withArgumentsInArray:@[orderId]];
//        if ([results next]) {
//            NSData *orderInfo = [results objectForColumn:@"orderInfo"];
//            WZOrder *order = [NSKeyedUnarchiver unarchiveObjectWithData:orderInfo];
//            order.orderState = WZOrderStateFinished;
//            order.myCommentId = @"C000000";
//            orderInfo = [NSKeyedArchiver archivedDataWithRootObject:order];
//            if ([db executeUpdate:@"UPDATE test_order SET orderState = ?, orderInfo = ? WHERE orderId = ?" withArgumentsInArray:@[[NSNumber numberWithUnsignedInteger:order.orderState], orderInfo, order.orderId]]) {
//                successBlock();
//            } else {
//                failureBlock(@"评价失败");
//            }
//        } else {
//            failureBlock(@"未找到订单");
//        }
//        [db close];
//    });
//}
//
//+ (void)prepareTestData {
//    WZOrder *testOrder1 = [[WZOrder alloc] initWithDataDictionary:@{@"orderId" : @"201903311206240001",
//                                                                    @"orderTimeStamp" : @"2019-03-31 12:06:24",
//                                                                    @"orderState" : [NSNumber numberWithUnsignedInteger:WZOrderStateWaitingPayment],
//                                                                    @"sponsorId" : @"S000001",
//                                                                    @"sponsorName" : @"浙江省足球协会",
//                                                                    @"eventId" : @"E000001",
//                                                                    @"eventAvatar" : @"OrderTest",
//                                                                    @"eventTitle" : @"宁波足球赛",
//                                                                    @"eventSeason" : @"2019-04-20 19:00:00\n宁波市鄞州区",
//                                                                    @"eventPrice" : @"300.00",
//                                                                    @"purchaseCount" : @"1",
//                                                                    @"orderAmount" : @"300.00",
//                                                                    @"orderDiscount" : @"0.00",
//                                                                    @"actualAmount" : @"300.00",}];
//    NSMutableArray *orders = [NSMutableArray arrayWithObjects:testOrder1, nil];
//    NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    if (![db open]) {
//        NSLog(@"数据库打开失败");
//        return;
//    }
//    NSString *sql = @"CREATE TABLE IF NOT EXISTS test_order(orderId TEXT PRIMARY KEY, orderState INTEGER, orderInfo BLOB)";
//    if ([db executeUpdate:sql]) {
//        NSLog(@"数据库创建成功");
//    } else {
//        NSLog(@"数据库创建失败");
//        [db close];
//        return;
//    }
//    for (NSUInteger i = 0; i < orders.count; i++) {
//        WZOrder *order = orders[i];
//        NSData *orderInfo = [NSKeyedArchiver archivedDataWithRootObject:order];
//        if ([db executeUpdate:@"INSERT INTO test_order(orderId, orderState, orderInfo) VALUES(?, ?, ?)" withArgumentsInArray:@[order.orderId, [NSNumber numberWithUnsignedInteger:order.orderState], orderInfo]]) {
//            NSLog(@"数据库插入成功");
//        } else {
//            NSLog(@"数据库插入失败");
//        }
//    }
//    [db close];
//}
//
//+ (void)addTestData {
//    NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    if (![db open]) {
//        NSLog(@"数据库打开失败");
//        return;
//    }
//    WZOrder *testOrder = [[WZOrder alloc] initWithDataDictionary:@{@"orderId" : @"201901111404080001",
//                                                                   @"orderTimeStamp" : @"2019-01-11 14:04:08",
//                                                                   @"orderState" : [NSNumber numberWithUnsignedInteger:WZOrderStateWaitingComment],
//                                                                   @"sponsorId" : @"S000002",
//                                                                   @"sponsorName" : @"一个名字很长很长很长很长很长很长很长很长很长的主办方",
//                                                                   @"eventId" : @"E000002",
//                                                                   @"eventAvatar" : @"Setting",
//                                                                   @"eventTitle" : @"一个名字很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的活动",
//                                                                   @"eventSeason" : @"2019-01-11 18:00:00\n一个名字很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的地点",
//                                                                   @"eventPrice" : @"1000.00",
//                                                                   @"purchaseCount" : @"1",
//                                                                   @"orderAmount" : @"1000.00",
//                                                                   @"orderDiscount" : @"100.00",
//                                                                   @"actualAmount" : @"900.00",
//                                                                   @"paymentMethod" : [NSNumber numberWithUnsignedInteger:WZOrderPaymentMethodAlipay],
//                                                                   @"paymentTimeStamp" : @"2019-01-11 14:04:42",
//                                                                   @"certificationNumber" : @"1229809587909639",
//                                                                   @"myCommentId" : @"C000002"}];
//    NSData *orderInfo = [NSKeyedArchiver archivedDataWithRootObject:testOrder];
//    if ([db executeUpdate:@"INSERT INTO test_order(orderId, orderState, orderInfo) VALUES(?, ?, ?)" withArgumentsInArray:@[testOrder.orderId, [NSNumber numberWithUnsignedInteger:testOrder.orderState], orderInfo]]) {
//        NSLog(@"数据库插入成功");
//    } else {
//        NSLog(@"数据库插入失败");
//    }
//    [db close];
//}
//
//+ (void)dropTestData {
//    NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    if (![db open]) {
//        NSLog(@"数据库打开失败");
//        return;
//    }
//    if ([db executeUpdate:@"DELETE FROM test_order"]) {
//        NSLog(@"数据库删除成功");
//    } else {
//        NSLog(@"数据库删除失败");
//    }
//    [db close];
//}

@end
