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

#import "AFNetworking.h"
#import "FMDatabase.h"

#define SANDBOX_DOCUMENT_PATH       NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define SANDBOX_CACHES_PATH         NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
#define DEFAULT_FILE_MANAGER        [NSFileManager defaultManager]

@implementation WZOrder

- (instancetype)initWithDataDictionary:(NSDictionary *)dataDictionary {
    if (self = [super init]) {
        NSArray *properties = [WZObjectDictionaryConverter propertiesArrayOfClass:[self class]];
        for (NSString *property in properties) {
            if (dataDictionary[property] != [NSNull null]) {
                [self setValue:dataDictionary[property] forKey:property];
            }
        }
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

+ (void)loadOrderListWithOrderState:(WZOrderState)orderState success:(void (^)(NSMutableArray *orders))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:0.5];
        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            failureBlock(@"数据库打开失败");
            return;
        }
        FMResultSet *results;
        if (orderState == WZOrderStateAllState) {
            results = [db executeQuery:@"SELECT * FROM test_order ORDER BY orderId DESC"];
        } else {
            results = [db executeQuery:@"SELECT * FROM test_order WHERE orderState = ? ORDER BY orderId DESC" withArgumentsInArray:@[[NSNumber numberWithUnsignedInteger:orderState]]];
        }
        NSMutableArray *orders = [NSMutableArray arrayWithCapacity:10];
        while ([results next]) {
            NSData *orderInfo = [results objectForColumn:@"orderInfo"];
            WZOrder *order = [NSKeyedUnarchiver unarchiveObjectWithData:orderInfo];
            [orders addObject:order];
        }
        [db close];
        successBlock(orders);
    });
}

+ (void)loadOrder:(NSString *)orderId success:(void (^)(WZOrder *order))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:0.5];
        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            failureBlock(@"数据库打开失败");
            return;
        }
        FMResultSet *results;
        results = [db executeQuery:@"SELECT * FROM test_order WHERE orderId = ?" withArgumentsInArray:@[orderId]];
        if ([results next]) {
            NSData *orderInfo = [results objectForColumn:@"orderInfo"];
            WZOrder *order = [NSKeyedUnarchiver unarchiveObjectWithData:orderInfo];
            successBlock(order);
        } else {
            failureBlock(@"未找到订单");
        }
        [db close];
    });
}

+ (void)payOrder:(NSString *)orderId withPaymentMethod:(WZOrderPaymentMethod)method success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            failureBlock(@"数据库打开失败");
            return;
        }
        FMResultSet *results;
        results = [db executeQuery:@"SELECT * FROM test_order WHERE orderId = ?" withArgumentsInArray:@[orderId]];
        if ([results next]) {
            NSData *orderInfo = [results objectForColumn:@"orderInfo"];
            WZOrder *order = [NSKeyedUnarchiver unarchiveObjectWithData:orderInfo];
            order.orderState = WZOrderStateWaitingParticipation;
            order.paymentMethod = method;
            order.paymentTimeStamp = [WZDateStringConverter stringFromDate:[NSDate date]];
            order.certificationNumber = [WZRandomStringGenerator randomStringFromSourceString:@"0123456789" length:16];
            orderInfo = [NSKeyedArchiver archivedDataWithRootObject:order];
            if ([db executeUpdate:@"UPDATE test_order SET orderState = ?, orderInfo = ? WHERE orderId = ?" withArgumentsInArray:@[[NSNumber numberWithUnsignedInteger:order.orderState], orderInfo, order.orderId]]) {
                successBlock();
            } else {
                failureBlock(@"支付失败");
            }
        } else {
            failureBlock(@"未找到订单");
        }
        [db close];
    });
}

+ (void)cancelOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            failureBlock(@"数据库打开失败");
            return;
        }
        FMResultSet *results;
        results = [db executeQuery:@"SELECT * FROM test_order WHERE orderId = ?" withArgumentsInArray:@[orderId]];
        if ([results next]) {
            NSData *orderInfo = [results objectForColumn:@"orderInfo"];
            WZOrder *order = [NSKeyedUnarchiver unarchiveObjectWithData:orderInfo];
            order.orderState = WZOrderStateCanceled;
            orderInfo = [NSKeyedArchiver archivedDataWithRootObject:order];
            if ([db executeUpdate:@"UPDATE test_order SET orderState = ?, orderInfo = ? WHERE orderId = ?" withArgumentsInArray:@[[NSNumber numberWithUnsignedInteger:order.orderState], orderInfo, order.orderId]]) {
                successBlock();
            } else {
                failureBlock(@"取消订单失败");
            }
        } else {
            failureBlock(@"未找到订单");
        }
        [db close];
    });
}

+ (void)refundOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            failureBlock(@"数据库打开失败");
            return;
        }
        FMResultSet *results;
        results = [db executeQuery:@"SELECT * FROM test_order WHERE orderId = ?" withArgumentsInArray:@[orderId]];
        if ([results next]) {
            NSData *orderInfo = [results objectForColumn:@"orderInfo"];
            WZOrder *order = [NSKeyedUnarchiver unarchiveObjectWithData:orderInfo];
            order.orderState = WZOrderStateRefunding;
            orderInfo = [NSKeyedArchiver archivedDataWithRootObject:order];
            if ([db executeUpdate:@"UPDATE test_order SET orderState = ?, orderInfo = ? WHERE orderId = ?" withArgumentsInArray:@[[NSNumber numberWithUnsignedInteger:order.orderState], orderInfo, order.orderId]]) {
                successBlock();
            } else {
                failureBlock(@"申请退款失败");
            }
        } else {
            failureBlock(@"未找到订单");
        }
        [db close];
    });
}

+ (void)deleteOrder:(NSString *)orderId success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            failureBlock(@"数据库打开失败");
            return;
        }
        if ([db executeUpdate:@"DELETE FROM test_order WHERE orderId = ?" withArgumentsInArray:@[orderId]]) {
            successBlock();
        } else {
            failureBlock(@"删除订单失败");
        }
        [db close];
    });
}

#pragma mark - Test

+ (void)prepareTestData {
    WZOrder *testOrder1 = [[WZOrder alloc] initWithDataDictionary:@{@"orderId" : @"201811241430300001",
                                                                    @"orderTimeStamp" : @"2018-11-24 14:30:30",
                                                                    @"orderState" : @1,
                                                                    @"sponsorId" : @"S000001",
                                                                    @"sponsorName" : @"万众艺兴",
                                                                    @"eventId" : @"E000001",
                                                                    @"eventAvatar" : @"Setting",
                                                                    @"eventTitle" : @"万众艺兴测试活动名字会很长",
                                                                    @"eventSeason" : @"2018-11-30 15:30:00\n浙江大学软件学院",
                                                                    @"eventPrice" : @"1000000.00",
                                                                    @"purchaseCount" : @"1",
                                                                    @"orderDiscount" : @"0.00",
                                                                    @"orderAmount" : @"1000000.00",
                                                                    @"paymentMethod" : @0,
                                                                    @"paymentTimeStamp" : @"2018-11-24 14:32:03",
                                                                    @"certificationNumber" : @"7437287382",
                                                                    @"myCommentId" : @"C000001"}];
    WZOrder *testOrder2 = [[WZOrder alloc] initWithDataDictionary:@{@"orderId" : @"201811260934140001",
                                                                    @"orderTimeStamp" : @"2018-11-26 09:34:14",
                                                                    @"orderState" : @3,
                                                                    @"sponsorId" : @"S000002",
                                                                    @"sponsorName" : @"浙江大学软件学院",
                                                                    @"eventId" : @"E000002",
                                                                    @"eventAvatar" : @"Setting",
                                                                    @"eventTitle" : @"实训项目评审",
                                                                    @"eventSeason" : @"2018-12-04 13:00:00\n浙江大学软件学院N312",
                                                                    @"eventPrice" : @"0.00",
                                                                    @"purchaseCount" : @"3",
                                                                    @"orderDiscount" : @"0.00",
                                                                    @"orderAmount" : @"0.00",
                                                                    @"paymentMethod" : @0,
                                                                    @"paymentTimeStamp" : @"2018-11-26 09:34:18",
                                                                    @"certificationNumber" : @"7328923112",
                                                                    @"myCommentId" : @"C000006"}];
    WZOrder *testOrder3 = [[WZOrder alloc] initWithDataDictionary:@{@"orderId" : @"201811281409480001",
                                                                    @"orderTimeStamp" : @"2018-11-28 14:09:48",
                                                                    @"orderState" : @2,
                                                                    @"sponsorId" : @"S000003",
                                                                    @"sponsorName" : @"浙大软院1808班",
                                                                    @"eventId" : @"E000003",
                                                                    @"eventAvatar" : @"Setting",
                                                                    @"eventTitle" : @"校歌彩排",
                                                                    @"eventSeason" : @"2018-12-04 20:00:00\n舞蹈室",
                                                                    @"eventPrice" : @"0.00",
                                                                    @"purchaseCount" : @"60",
                                                                    @"orderDiscount" : @"0.00",
                                                                    @"orderAmount" : @"0.00",
                                                                    @"paymentMethod" : @0,
                                                                    @"paymentTimeStamp" : @"2018-11-28 14:09:54",
                                                                    @"certificationNumber" : @"2190002812",
                                                                    @"myCommentId" : @"C000004"}];
    WZOrder *testOrder4 = [[WZOrder alloc] initWithDataDictionary:@{@"orderId" : @"201812042209030001",
                                                                    @"orderTimeStamp" : @"2018-12-04 22:09:03",
                                                                    @"orderState" : @1,
                                                                    @"sponsorId" : @"S000002",
                                                                    @"sponsorName" : @"浙江大学软件学院",
                                                                    @"eventId" : @"E000004",
                                                                    @"eventAvatar" : @"Setting",
                                                                    @"eventTitle" : @"六级考试包车",
                                                                    @"eventSeason" : @"2018-12-15 09:00:00\n浙江大学软件学院",
                                                                    @"eventPrice" : @"60.00",
                                                                    @"purchaseCount" : @"1",
                                                                    @"orderDiscount" : @"0.00",
                                                                    @"orderAmount" : @"60.00",
                                                                    @"paymentMethod" : @1,
                                                                    @"paymentTimeStamp" : @"2018-12-04 23:00:12",
                                                                    @"certificationNumber" : @"8761987409",
                                                                    @"myCommentId" : @"C000005"}];
    NSMutableArray *orders = [NSMutableArray arrayWithObjects:testOrder1, testOrder2, testOrder3, testOrder4, nil];
    
    NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    NSString *sql = @"CREATE TABLE IF NOT EXISTS test_order(orderId TEXT PRIMARY KEY, orderState INTEGER, orderInfo BLOB)";
    if ([db executeUpdate:sql]) {
        NSLog(@"数据库创建成功");
    } else {
        NSLog(@"数据库创建失败");
        [db close];
        return;
    }
    for (NSUInteger i = 0; i < orders.count; i++) {
        WZOrder *order = orders[i];
        NSData *orderInfo = [NSKeyedArchiver archivedDataWithRootObject:order];
        if ([db executeUpdate:@"INSERT INTO test_order(orderId, orderState, orderInfo) VALUES(?, ?, ?)" withArgumentsInArray:@[order.orderId, [NSNumber numberWithUnsignedInteger:order.orderState], orderInfo]]) {
            NSLog(@"数据库插入成功");
        } else {
            NSLog(@"数据库插入失败");
        }
    }
    [db close];
}

+ (void)addTestData {
    NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    WZOrder *testOrder = [[WZOrder alloc] initWithDataDictionary:@{@"orderId" : @"201812141800000001",
                                                                   @"orderTimeStamp" : @"2018-12-14 18:00:00",
                                                                   @"orderState" : @6,
                                                                   @"sponsorId" : @"S000002",
                                                                   @"sponsorName" : @"一个名字很长很长很长很长很长很长很长很长很长的主办方",
                                                                   @"eventId" : @"E000000",
                                                                   @"eventAvatar" : @"Setting",
                                                                   @"eventTitle" : @"一个名字很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的活动",
                                                                   @"eventSeason" : @"2018-12-14 18:00:00\n一个名字很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的地点",
                                                                   @"eventPrice" : @"1000.00",
                                                                   @"purchaseCount" : @"1",
                                                                   @"orderDiscount" : @"100.00",
                                                                   @"orderAmount" : @"900.00",
                                                                   @"paymentMethod" : @0,
                                                                   @"paymentTimeStamp" : @"2018-12-14 18:00:00",
                                                                   @"certificationNumber" : @"1287909639",
                                                                   @"myCommentId" : @"C000090"}];
    NSData *orderInfo = [NSKeyedArchiver archivedDataWithRootObject:testOrder];
    if ([db executeUpdate:@"INSERT INTO test_order(orderId, orderState, orderInfo) VALUES(?, ?, ?)" withArgumentsInArray:@[testOrder.orderId, [NSNumber numberWithUnsignedInteger:testOrder.orderState], orderInfo]]) {
        NSLog(@"数据库插入成功");
    } else {
        NSLog(@"数据库插入失败");
    }
    [db close];
}

+ (void)dropTestData {
    NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:@"TestOrder.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    if ([db executeUpdate:@"DELETE FROM test_order"]) {
        NSLog(@"数据库删除成功");
    } else {
        NSLog(@"数据库删除失败");
    }
    [db close];
}

@end
