//
//  ASampleManager.h
//  Pods-CategoryCoverOrigin
//
//  Created by dongshangxian on 2018/4/11.
//  Copyright © 2018年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASampleManager : NSObject

+ (ASampleManager *)sharedInstance;
    
- (NSDictionary *)currentNumberDict;

@end

NS_ASSUME_NONNULL_END
