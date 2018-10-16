//
//  NSObject+WMScheduler.m
//  WaimaiPlatform
//
//  Created by dongshangxian on 2018/4/11.
//  Copyright © 2018年 meituan. All rights reserved.
//

#import "NSObject+WMScheduler.h"

@implementation NSObject(WMScheduler)

- (nullable id)wm_executeMethod:(nullable SEL)selector
{
    return [[WMSchedulerCore sharedInstance] wm_executeInstanceMethod:selector inTarget:self params:nil];
}
- (nullable id)wm_executeMethod:(nullable SEL)selector params:(nullable NSArray *)params
{
    return [[WMSchedulerCore sharedInstance] wm_executeInstanceMethod:selector inTarget:self params:params];
}

@end
