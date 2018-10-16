//
//  WMScheduler.h
//  WaimaiPlatform
//
//  Created by dongshangxian on 2018/4/11.
//  Copyright © 2018年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(uint16_t, WMSCHEDULER_ERROR_RES) {
    WMS_ERROR_RES_PARAM = 10,
    WMS_ERROR_RES_RESPONSE = 20,
    WMS_ERROR_RES_METHODSIG = 30,
    WMS_ERROR_RES_RETTYPE = 40,
    WMS_ERROR_RES_NILCLASS = 50,
    WMS_ERROR_RES_ARGUMENTS = 60
};

@interface WMSchedulerCore : NSObject

+ (nonnull instancetype)sharedInstance;

/**
 * 通过一个url去跨组件调用方法
 * 一般用于无参数或是参数全部是基本数据类型，可以这样方便调用
 * 例： imeituanwaimai://WMSigleton/getOrderNumberWithPoi:?poiid=666
 * @param url  scheme为外卖的完整url
 */
- (nullable id)wm_executeMethodWithUrl:(nonnull NSURL *)url;

/**
 * 跨组件调用实例方法获得返回值
 * 一般用于参数中有特殊类型或是对象类型
 * @param method 需要调用的方法
 * @param target 需要调用方法的对象
 * @param params 参数列表使用数组而不是字典，因为key实际上用不到，只保留value，并且用数组的话还有index， 并且传参时也比较方便
 */
- (nullable id)wm_executeInstanceMethod:(nonnull SEL)method inTarget:(nonnull id )target params:(nullable NSArray *)params;

/**
 * 跨组件调用类方法获得返回值
 * 一般用于参数中有特殊类型或是对象类型
 * @param method 需要调用的方法
 * @param className 需要调用类方法的类
 * @param params 参数列表使用数组而不是字典，因为key实际上用不到，只保留value，并且用数组的话还有index， 并且传参时也比较方便
 */
- (nullable id)wm_executeClassMethod:(nonnull SEL)method inTarget:(nonnull char *)className params:(nullable NSArray *)params;

/**
 * 通过名字获得Class
 * @param className 名称
 */
- (nullable Class)getClassWithName:(nonnull char *)className;

@end
