//
//  BHomeViewController.m
//  Pods-CategoryCoverOrigin
//
//  Created by dongshangxian on 2018/4/11.
//  Copyright © 2018年 meituan. All rights reserved.
//

#import "BHomeViewController.h"
#import <WMPlatformPKit/WMScheduler.h>

@interface BHomeViewController()
@property (nonatomic, strong) UILabel * topLabel;
@end
@implementation BHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 实际的调用方就这一行实现跨组件调用方法
    NSInteger currentBadge = [WMScheduler wms_getShopCartBadgeWithPoiID:@"0001"];
    
    self.topLabel = [[UILabel alloc]init];
    [self.topLabel setText:[NSString stringWithFormat:@"%ld",currentBadge]];
    NSLog(@"门店ID为0001的商铺 当前的已选商品数量为%@",self.topLabel.text);
}

@end
