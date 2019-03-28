//
//  WZComment.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/3/28.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZComment.h"
#import "WZDateStringConverter.h"
#import "FMDatabase.h"

#define SANDBOX_DOCUMENT_PATH       NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define COMMENT_DATABASE_NAME       @"Comment.db"

@implementation WZComment

- (instancetype)initWithId:(NSString *)eventId commenter:(NSString *)commenter text:(NSString *)commentText level:(NSInteger)commentLevel date:(NSString *)commentDate {
    if (self = [super init]) {
        self.eventId = eventId;
        self.commenter = commenter;
        self.commentText = commentText;
        self.commentLevel = commentLevel;
        self.commentDate = commentDate;
    }
    return self;
}

+ (void)createCommentDB {
    NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:COMMENT_DATABASE_NAME];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    NSString *sql = @"CREATE TABLE IF NOT EXISTS test_comment(eventId TEXT, commentText TEXT, commentLevel INTEGER)";
    if ([db executeUpdate:sql]) {
        NSLog(@"数据库创建成功");
    } else {
        NSLog(@"数据库创建失败");
    }
    [db close];
}

+ (void)commentEvent:(NSString *)eventId withCommenter:(NSString *)commenter commentText:(NSString *)commentText commentlevel:(NSInteger)commentLevel success:(void (^)(void))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:COMMENT_DATABASE_NAME];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            failureBlock(@"数据库打开失败");
            return;
        }
        NSString *sql = @"CREATE TABLE IF NOT EXISTS test_comment(eventId TEXT, commenter TEXT, commentText TEXT, commentLevel INTEGER, commentDate TEXT)";
        if ([db executeUpdate:sql]) {
            NSLog(@"数据库创建成功");
        } else {
            NSLog(@"数据库创建失败");
        }
        NSString *commentDate = [WZDateStringConverter stringFromDate:[NSDate date]];
        if ([db executeUpdate:@"INSERT INTO test_comment(eventId, commenter, commentText, commentLevel, commentDate) VALUES(?, ?, ?, ?, ?)" withArgumentsInArray:@[eventId, commenter, commentText, [NSNumber numberWithInteger:commentLevel], commentDate]]) {
            successBlock();
        } else {
            failureBlock(@"评价失败");
        }
        [db close];
    });
}

+ (void)downloadCommentForEvent:(NSString *)eventId success:(void (^)(NSArray *comments))successBlock failure:(void (^)(NSString *userInfo))failureBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *dbPath = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:COMMENT_DATABASE_NAME];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            failureBlock(@"数据库打开失败");
            return;
        }
        FMResultSet *results;
        results = [db executeQuery:@"SELECT * FROM test_comment WHERE eventId = ?" withArgumentsInArray:@[eventId]];
        NSMutableArray *comments = [[NSMutableArray alloc] init];
        while ([results next]) {
            WZComment *comment = [[WZComment alloc] initWithId:[results objectForColumn:@"eventId"] commenter:[results objectForColumn:@"commenter"] text:[results objectForColumn:@"commentText"] level:[results intForColumn:@"commentLevel"] date:[results objectForColumn:@"commentDate"]];
            [comments addObject:comment];
        }
        successBlock(comments);
        [db close];
    });
}

@end
