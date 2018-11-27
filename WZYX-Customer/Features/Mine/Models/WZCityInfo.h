//
//  WZCityInfo.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2018/11/25.
//  Copyright © 2018年 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZCityInfo : NSObject

@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSArray *cities;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
