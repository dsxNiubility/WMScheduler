//
//  WMScheduler.h
//  Pods-CategoryCoverOrigin
//
//  Created by dongshangxian on 2018/4/11.
//  Copyright © 2018年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMScheduler : NSObject

    
#pragma mark - A
    
/**
 获取当前商家的购物车已选数量
 @return 已选数量
 @param poiID 门店ID
 */
+ (NSUInteger)wms_getShopCartBadgeWithPoiID:(NSString *)poiID;

    
@end
