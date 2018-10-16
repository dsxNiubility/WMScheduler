//
//  WMScheduler.m
//  WaimaiPlatform
//
//  Created by dongshangxian on 2018/4/11.
//  Copyright © 2018年 meituan. All rights reserved.
//

#import "WMSchedulerCore.h"
#import <objc/runtime.h>

#define CompareTypeAndReturn(type) \
if (strcmp(retType, @encode(type)) == 0) {\
type result = 0;\
[invocation getReturnValue:&result];\
return @(result);\
}

#define CompareTypeAndSetArgument(type,typeValue) \
else if (strcmp(currentArgumentType, @encode(type)) == 0){\
type argumentValue = [(NSNumber *)obj typeValue];\
[invocation setArgument:&argumentValue atIndex:(2 + idx)];\
}

#define CreateNSError(errorCode,errorMessage) [NSError errorWithDomain:NSCocoaErrorDomain code:errorCode userInfo:@{@"message":errorMessage}]

@interface WMSchedulerCore() 

@end


@implementation WMSchedulerCore


+ (instancetype)sharedInstance
{
    static WMSchedulerCore *scheduler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scheduler = [[WMSchedulerCore alloc] init];
    });
    return scheduler;
}

/**
 * 通过一个url去跨组件调用方法
 * 一般用于无参数或是参数全部是基本数据类型，可以这样方便调用
 * 例： imeituanwaimai://WMSigleton/getOrderNumberWithPoi:?poiid=666
 * @param url  scheme为外卖的完整url
 */
- (nullable id)wm_executeMethodWithUrl:(NSURL *)url
{
    // 防止远程调用URL遭到黑客劫持，需要对URL的增加一些校验
    NSError *error = nil;
    if (nil == url.host || url.host.length > 255 || [url.host containsString:@"eval("])
    {
        error = CreateNSError(WMS_ERROR_RES_PARAM,@"url里的target输入不合法");
    }
    
    if (nil == url.path || url.path.length > 255 || [url.path containsString:@"eval("])
    {
        error = CreateNSError(WMS_ERROR_RES_PARAM,@"url里的action输入不合法");
    }
    
    if (url.query.length > 255 || [url.query containsString:@"eval("])
    {
        error = CreateNSError(WMS_ERROR_RES_PARAM,@"url里的param输入不合法");
    }
    NSString *errormsg =[NSString stringWithFormat:@"WMScheduler Assert:%@",error];
    if (error) {
        NSAssert(nil == error,errormsg);
        return nil;
    }
    
    NSMutableArray *params = [NSMutableArray array];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *items = [param componentsSeparatedByString:@"="];
        if([items count] < 2) continue;
        // params使用数组而不是字典，因为key实际上用不到，只保留value，并且用数组的话还有index
        [params addObject:items.lastObject];
    }
    NSString *methodName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return [self wm_executeInstanceMethod:NSSelectorFromString(methodName) inTarget:url.host params:params];
}


/**
 * 跨组件调用实例方法获得返回值
 * 一般用于参数中有特殊类型或是对象类型
 * @param method 需要调用的方法
 * @param target 需要调用方法的对象
 * @param params 参数列表使用数组而不是字典，因为key实际上用不到，只保留value，并且用数组的话还有index， 并且传参时也比较方便
 */
- (nullable id)wm_executeInstanceMethod:(nonnull SEL)method inTarget:(nonnull id )target params:(nullable NSArray *)params
{
    @autoreleasepool{
        id result = [self wm_processErrorWithMethod:method inTarget:target params:params];
        if ([result isKindOfClass:[NSError class]]) {
            NSString *errormsg =[NSString stringWithFormat:@"WMScheduler Assert:%@",(NSError *)result];
            NSAssert(![result isKindOfClass:[NSError class]],errormsg);
            return nil;
        }else{
            return result;
        }
    }
}

- (nullable id)wm_processErrorWithMethod:(nonnull SEL)method inTarget:(nonnull id )target params:(nullable NSArray *)params{
    if (NULL == method) {
        return CreateNSError(WMS_ERROR_RES_PARAM,@"请传入一个非空的选择子");
    }
    if (nil == target) {
        return CreateNSError(WMS_ERROR_RES_PARAM,@"请传入一个非空的对象");
    }
    if (![target respondsToSelector:method]) {
        return CreateNSError(WMS_ERROR_RES_RESPONSE,@"未被实现的方法");
    }
    NSMethodSignature* methodSig = [target methodSignatureForSelector:method];
    if(nil == methodSig) {
        return CreateNSError(WMS_ERROR_RES_METHODSIG,@"未取到方法签名");
    }
    if ( ([methodSig numberOfArguments]-2) != params.count) {
        return CreateNSError(WMS_ERROR_RES_ARGUMENTS,@"方法实际的参数个数，与params数组不对等！（提示：想传nil的地方用[NSNull null]代替）");
    };
    
    NSMethodSignature* methodSig2 = [@100 methodSignatureForSelector:@selector(longLongValue)];
    const char *returnaa = [methodSig2 methodReturnType];
    NSLog(@"WMScheduleraa：获取的方法签名为%@,返回值类型为%s",methodSig2,returnaa);
    
    const char* retType = [methodSig methodReturnType];
    NSLog(@"WMScheduler：获取的方法签名为%@,返回值类型为%s",methodSig,retType);
    
//     返回值为对象类型的处理
//    if (strcmp(retType, @encode(id)) == 0) {//TODO 入参少于两个参数且为值类型不能走performSelector，暂时注掉
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        switch (params.count) {
//            case 0:
//                return [target performSelector:method];
//                break;
//            case 1:
//                // 如果是NSNull 则直接传nil
//                return [target performSelector:method withObject:(params.firstObject != [NSNull null] ? params.firstObject : nil)];
//                break;
//            case 2:
//                return [target performSelector:method withObject:(params.firstObject != [NSNull null] ? params.firstObject : nil) withObject:(params.lastObject != [NSNull null] ? params.lastObject : nil)];
//                break;
//            default:
//                // 不做任何操作，把参数比较多的返回值为id类型的场景漏下去，让invocation处理
//                break;
//        }
//#pragma clang diagnostic pop
//    }
    
    // 不同的返回值类型，invocation的创建与执行方式相同
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [params enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == [NSNull null]) {
            obj = nil;
        } // 外部传[NSNull null]来代替nil，用于你想给谁set nil的需求
        const char* currentArgumentType = [methodSig getArgumentTypeAtIndex:2 + idx];
        if (strcmp(currentArgumentType, @encode(id)) == 0){
            // 入参是对象类型的处理 非 number
            [invocation setArgument:&obj atIndex:(2 + idx)];
        }else if (strcmp(currentArgumentType, @encode(CGFloat)) == 0){
#if defined(__LP64__) && __LP64__
            CGFloat argumentValue = [(NSNumber *)obj doubleValue];
#else
            CGFloat argumentValue = [(NSNumber *)obj floatValue];
#endif
            [invocation setArgument:&argumentValue atIndex:(2 + idx)];
        }
        // 常用类型
        CompareTypeAndSetArgument(int, intValue)
        CompareTypeAndSetArgument(BOOL, boolValue)
        CompareTypeAndSetArgument(NSInteger, integerValue)
        CompareTypeAndSetArgument(long long, longLongValue)
        // 非常用类型
        CompareTypeAndSetArgument(float, floatValue)
        CompareTypeAndSetArgument(double, doubleValue)
        CompareTypeAndSetArgument(short, shortValue)
        CompareTypeAndSetArgument(unsigned short, unsignedShortValue)
        CompareTypeAndSetArgument(unsigned int, unsignedIntValue)
        CompareTypeAndSetArgument(NSUInteger, unsignedIntegerValue)
        CompareTypeAndSetArgument(unsigned long long, unsignedLongLongValue)
        CompareTypeAndSetArgument(char, charValue)
        CompareTypeAndSetArgument(unsigned char, unsignedCharValue)
        else{
            [invocation setArgument:&obj atIndex:(2 + idx)];
        }
    }];
    [invocation setSelector:method];
    [invocation setTarget:target];
    [invocation invoke];
    
    // 没有返回值情况下的处理
    if (strcmp(retType, @encode(void)) == 0) {
        return nil;
    }
    
    // 返回值类型为基本数据类型的处理（包装成NSNumber返回）
    if (strcmp(retType, @encode(int)) == 0) {
        int result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    // 基本数据类型用宏包裹了
    CompareTypeAndReturn(NSInteger)
    CompareTypeAndReturn(NSUInteger)
    CompareTypeAndReturn(CGFloat)
    CompareTypeAndReturn(char)
    CompareTypeAndReturn(short)
    CompareTypeAndReturn(float)
    CompareTypeAndReturn(double)
    CompareTypeAndReturn(long long)
    CompareTypeAndReturn(BOOL)
    CompareTypeAndReturn(unsigned char)
    CompareTypeAndReturn(unsigned short)
    CompareTypeAndReturn(unsigned long long)
    
    // 返回值为Class类型
    if (strcmp(retType, @encode(Class)) == 0) {
        __autoreleasing Class class = nil;
        [invocation getReturnValue:&class];
        return class;
    }
    // 能到这里的id，就是参数数量多于2个的
    if (strcmp(retType, @encode(id)) == 0) {
        __autoreleasing id obj = nil;
        [invocation getReturnValue:&obj];
        return obj;
    }
    // 再然后剩下的返回类型就剩下 结构体、联合体、c数组、选择子 等少见类型了
    NSString *returnErrorStr = [NSString stringWithFormat:@"该方法返回值类型不支持，类型为%s",retType];
    return CreateNSError(WMS_ERROR_RES_RETTYPE,returnErrorStr);
}

/**
 * 跨组件调用类方法获得返回值
 * 一般用于参数中有特殊类型或是对象类型
 * @param method 需要调用的方法
 * @param className 需要调用类方法的类
 * @param params 参数列表使用数组而不是字典，因为key实际上用不到，只保留value，并且用数组的话还有index， 并且传参时也比较方便
 */
- (nullable id)wm_executeClassMethod:(nonnull SEL)method inTarget:(nonnull char *)className params:(nullable NSArray *)params
{
    Class class = [self getClassWithName:className];
    return [self wm_executeInstanceMethod:method inTarget:class params:params];
}

- (nullable Class)getClassWithName:(nonnull char *)className
{
    NSError *error = nil;
    if (nil == className) {
        error = CreateNSError(WMS_ERROR_RES_PARAM,@"入参不合法");
    }
    Class class = objc_getClass(className);
    if (Nil == class) {
        error = CreateNSError(WMS_ERROR_RES_NILCLASS,@"未找到对应的类");
    }
    NSString *errormsg =[NSString stringWithFormat:@"WMScheduler Assert:%@",error];
    if (error) {
        NSAssert(nil != error,errormsg);
        return nil;
    }else{
        return class;
    }
}

@end
