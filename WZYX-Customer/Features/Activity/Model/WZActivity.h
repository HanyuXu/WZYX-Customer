//
//  WZActivity.h
//  WZYX-Customer
//
//  Created by 冯夏巍 on 2019/2/25.
//  Copyright © 2019 WZYX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZActivity : NSObject

@property (nonatomic, copy)     NSString    *pId;
@property (nonatomic, copy)     NSString    *pName;
@property (nonatomic, assign)   double      pPrice;
@property (nonatomic, assign)   NSInteger   pCapacity;
@property (nonatomic, copy)     NSString    *pImage;
@property (nonatomic, assign)   double      pLoggititute;
@property (nonatomic, assign)   double      pLatitute;
@property(nonatomic, copy)      NSString    *pLocation;
@property (nonatomic, strong)   NSString    *pStarttime;
@property (nonatomic, strong)   NSString     *pEndtime;
@property (nonatomic, strong)   NSArray     *pImageList;
@property(nonatomic, assign)    NSInteger    hasAdded;
- (instancetype) initWithDictionary: (NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
