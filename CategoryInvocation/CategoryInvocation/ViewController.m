//
//  ViewController.m
//  CategoryInvocation
//
//  Created by 董尚先 on 2018/10/9.
//  Copyright © 2018年 董尚先. All rights reserved.
//

#import "ViewController.h"
#import <WMBusinessBKit/BHomeViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    BHomeViewController *bHomeVc = [BHomeViewController new];
    [self.view addSubview:bHomeVc.view];
    [self addChildViewController:bHomeVc];
}


@end
