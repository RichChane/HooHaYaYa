//
//  CSAdvertiseVC.m
//  ChildStory
//
//  Created by gzkp on 2019/4/2.
//  Copyright © 2019年 HH. All rights reserved.
//

#import "CSAdvertiseVC.h"
#import "AppDelegate+LauchManager.h"

@interface CSAdvertiseVC ()

@end

@implementation CSAdvertiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createMainView];

}

- (void)createMainView
{
    UIView *adImvView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.8)];
    adImvView.backgroundColor = GC.BG;
    [self.view addSubview:adImvView];
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake( 0, adImvView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT*0.2)];
    downView.backgroundColor = GC.CWhite;
    [self.view addSubview:downView];
    CGFloat passBtnWidth = 45;
    CGFloat passBtnHeight = 30;
    UIButton *passBtn = [UIFactory createbtnWithTitle:ML(@"跳过") target:self select:@selector(passAction)];
    passBtn.backgroundColor = kUIColorFromRGBAlpha(0x000000, 0.2);
    passBtn.layer.cornerRadius = 4;
    passBtn.frame = CGRectMake(downView.width-15-passBtnWidth, 15, passBtnWidth, passBtnHeight);
    [downView addSubview:passBtn];
    
    
}

- (void)passAction
{
    [ToAppDelegate overAdvertise];
    
}


@end
