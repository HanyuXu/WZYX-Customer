//
//  WZRandomStringGenerator.m
//  WZYX-Customer
//
//  Created by 祈越 on 2019/1/6.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZRandomStringGenerator.h"

@implementation WZRandomStringGenerator

+ (NSString *)randomStringFromSourceString:(NSString *)sourceString length:(NSUInteger)length {
    NSUInteger sourceStringLength = sourceString.length;
    NSMutableString *randomString = [[NSMutableString alloc] initWithCapacity:length];
    for (int i = 0; i < length; i++) {
        NSUInteger index = arc4random() % sourceStringLength;
        char c = [sourceString characterAtIndex:index];
        [randomString appendFormat:@"%c", c];
    }
    return randomString;
}

@end
