//
//  WZObjectDictionaryConverter.m
//  WZYX-Customer
//
//  Created by 祈越 on 2018/12/8.
//  Copyright © 2018 WZYX. All rights reserved.
//

#import "WZObjectDictionaryConverter.h"
#import <objc/runtime.h>

@implementation WZObjectDictionaryConverter

+ (NSArray *)propertiesArrayOfClass:(Class)class {
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:outCount];
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        [propertiesArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    return propertiesArray;
}

+ (NSDictionary *)dictionaryPresentationOfObject:(id)obj {
    NSArray *properties = [WZObjectDictionaryConverter propertiesArrayOfClass:[obj class]];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:properties.count];
    for (NSString *property in properties) {
        if ([obj valueForKey:property] != nil) {
            [dictionary setObject:[obj valueForKey:property] forKey:property];
        } else {
            [dictionary setObject:[NSNull null] forKey:property];
        }
    }
    return dictionary;
}

@end
