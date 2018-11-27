//
//  WZCityInfo.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/25.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import "WZCityInfo.h"

@implementation WZCityInfo

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.province = dict[@"name"];
        self.cities = dict[@"cities"];
    }
    return self;
}

@end
