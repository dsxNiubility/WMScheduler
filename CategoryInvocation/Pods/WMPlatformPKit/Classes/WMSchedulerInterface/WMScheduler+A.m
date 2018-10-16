//
//  WMScheduler+A.m
//  Pods-CategoryInvocation
//
//  Created by dongshangxian on 2018/4/11.
//  Copyright © 2018年 meituan. All rights reserved.
//

#import "WMScheduler.h"
#import "NSObject+WMScheduler.h"

@implementation WMScheduler (A)

+ (NSUInteger)wms_getShopCartBadgeWithPoiID:(NSString *)poiID{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id sharedManager = [wm_scheduler_getClass("ASampleManager") wm_executeMethod:@selector(sharedInstance)];
    
    NSDictionary *dict =[sharedManager wm_executeMethod:@selector(currentNumberDict)];
    
    UIView *y = [sharedManager wm_executeMethod:@selector(aaawithb:) params:@[@8888888888]];
    NSLog(@"%@",[y class]);
    
    return [[dict valueForKey:poiID] integerValue];
#pragma clang diagnostic pop
}

@end
