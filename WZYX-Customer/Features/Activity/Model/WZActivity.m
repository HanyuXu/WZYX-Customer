//
//  WZActivity.m
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/25.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import "WZActivity.h"

@implementation WZActivity
- (instancetype) initWithDictionary: (NSDictionary *)dict {
    if(self = [super init]){
        self.pId = dict[@"pId"];
        self.pName = dict[@"pName"];
        self.pPrice = [dict[@"pPrice"] doubleValue];
        self.pCapacity = [dict[@"pCapcity"] unsignedIntegerValue];
        self.pImage = dict[@"pImage"];
        self.pLoggititute = [dict[@"Longgitude"] doubleValue];
        self.pLatitute = [dict[@"pLatitude"] doubleValue];
        self.pLocation = dict[@"pLocation"];
        self.pStarttime = [dict[@"pStarttime"] unsignedIntegerValue];
        self.pEndtime = [dict[@"pEndtime"] unsignedIntegerValue];
    }
    return self;
}
@end
