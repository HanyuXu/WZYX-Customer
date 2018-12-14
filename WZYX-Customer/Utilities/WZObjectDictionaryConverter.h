//
//  WZObjectDictionaryConverter.h
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/8.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZObjectDictionaryConverter : NSObject

+ (NSArray *)propertiesArrayOfClass:(Class)class;
+ (NSDictionary *)dictionaryPresentationOfObject:(id)obj;

@end

NS_ASSUME_NONNULL_END
