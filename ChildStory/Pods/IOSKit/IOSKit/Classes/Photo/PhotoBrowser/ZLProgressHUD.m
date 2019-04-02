//
//  ZLProgressHUD.m
//  ZLPhotoBrowser
//
//  Created by long on 16/2/15.
//  Copyright © 2016年 long. All rights reserved.
//

#import "ZLProgressHUD.h"
#import "ZLDefine.h"

#import <KPFoundation/KPFoundation.h>
#import <ToastUtils.h>
@implementation ZLProgressHUD
{
    /// 是否从外部隐藏
    BOOL isHideFrowOutSide;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.frame = [UIScreen mainScreen].bounds;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 80)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0f;
    view.backgroundColor = [UIColor darkGrayColor];
    view.alpha = 0.8;
    view.center = self.center;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 15, 30, 30)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator startAnimating];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 100, 30)];
    lab.tag = 5000;
    [lab setAdjustsFontSizeToFitWidth:YES];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:16];
    lab.text = ML(@"处理中");
    
    [view addSubview:indicator];
    [view addSubview:lab];
    
    [self addSubview:view];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void)hide
{
    dispatch_async(dispatch_get_main_queue(), ^{
        isHideFrowOutSide = YES;
        [self removeFromSuperview];
    });
}

- (void)showWithTime:(NSInteger)time
{
    if (isHideFrowOutSide) {
        return;
    }
    
    UILabel * lab = [self viewWithTag:5000];
    lab.text = ML(@"处理中，请等待");
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isHideFrowOutSide) {
            return;
        }
        [self hideForTimeout];
    });
}

- (void)hideForTimeout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        isHideFrowOutSide = NO;
        [self removeFromSuperview];
        [self alertMessage];
    });
}

- (void)alertMessage {
    if (self.hudTimeOutBlock) {
        self.hudTimeOutBlock();
    }
}

@end
