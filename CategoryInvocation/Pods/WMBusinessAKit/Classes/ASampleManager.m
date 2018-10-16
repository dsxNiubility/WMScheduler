//
//  ASampleManager.m
//  Pods-CategoryInvocation
//
//  Created by dongshangxian on 2018/4/11.
//  Copyright © 2018年 meituan. All rights reserved.
//

#import "ASampleManager.h"
#import "ASampleEntity.h"

static ASampleManager *sharedManager = nil;
@interface ASampleManager()
@property (nonatomic, strong) NSDictionary * currentNumberDict;
@property (nonatomic, strong) ASampleEntity *currentEntity;
@end

@implementation ASampleManager

+ (ASampleManager *)sharedInstance
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[ASampleManager alloc] init];
            [sharedManager setCurrentEntity:[ASampleEntity new]];
            [sharedManager setCurrentNumberDict:@{@"0001":@5,@"0002":@3}];
        });
        return sharedManager;
}
    
- (NSDictionary *)currentNumberDict{
    return _currentNumberDict ? : [NSDictionary dictionary];
}
    
- (id)aaawithb:(long long)b{
    if (b == 8888888888) {
        NSLog(@"b到底是多少%lld",b);
        return [UILabel new];
    }else{
        NSLog(@"b到底是多少%lld",b);
        return [UIButton new];
    }
}
    
@end
