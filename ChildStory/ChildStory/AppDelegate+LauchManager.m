//
//  AppDelegate+LauchManager.m
//  ChildStory
//
//  Created by gzkp on 2019/4/2.
//  Copyright © 2019年 HH. All rights reserved.
//

#import "AppDelegate+LauchManager.h"
#import "CSAdvertiseVC.h"
#import "ViewController.h"

@implementation AppDelegate (LauchManager)

- (void)lauchAdvertise
{
    CSAdvertiseVC *vc = [[CSAdvertiseVC alloc]init];
    self.window.rootViewController = vc;
    
}

- (void)overAdvertise
{
    ViewController *vc = [[ViewController alloc]init];
    self.window.rootViewController = vc;
}

@end
