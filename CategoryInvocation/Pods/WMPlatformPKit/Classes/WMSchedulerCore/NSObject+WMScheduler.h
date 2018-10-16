//
//  NSObject+WMScheduler.h
//  WaimaiPlatform
//
//  Created by dongshangxian on 2018/4/11.
//  Copyright © 2018年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMSchedulerCore.h"

#define wm_scheduler_getClass(className) ([[WMSchedulerCore sharedInstance] getClassWithName:className])

@interface NSObject(WMScheduler)

- (nullable id)wm_executeMethod:(nullable SEL)selector;
- (nullable id)wm_executeMethod:(nullable SEL)selector params:(nullable NSArray *)params;

@end
