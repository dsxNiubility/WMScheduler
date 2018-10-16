//
//  WMScheduler+A.m
//  Pods-CategoryCoverOrigin
//
//  Created by dongshangxian on 2018/4/11.
//  Copyright © 2018年 meituan. All rights reserved.
//

#import "WMScheduler.h"
#import "ASampleManager.h"
#import "ASampleEntity.h"

@implementation WMScheduler (A)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
    
+ (NSUInteger)wms_getShopCartBadgeWithPoiID:(NSString *)poiID{
    ASampleManager *manager = [ASampleManager sharedInstance];
    NSDictionary *dict = [manager currentNumberDict];
    return [[dict valueForKey:poiID] integerValue];
}

#pragma clang diagnostic pop
@end
