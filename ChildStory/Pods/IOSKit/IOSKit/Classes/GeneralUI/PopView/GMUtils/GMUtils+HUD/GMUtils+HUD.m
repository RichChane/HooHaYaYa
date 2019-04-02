//
//  GMUtils+HUD.m
//  Gemo.com
//
//  Created by Horace.Yuan on 15/9/22.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "GMUtils+HUD.h"
#import "MBProgressHUD.h"
#import "GeneralConfig.h"
#import <KPFoundation/KPFoundation.h>

@implementation GMUtils (HUD)

+ (void)showQuickTipWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow]
                                              animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.label.text = text;
    double hideTime = 0.0;
    if (text.length < 10) {
        hideTime = 1.0f;
    }else if (text.length < 20){
        hideTime = 2.0f;
    }else{
        hideTime = 3.0f;
    }
    hud.label.numberOfLines = 0;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = kUIColorFromRGBAlpha(0x000000, 0.7);
    hud.contentColor = GC.CWhite;
    [hud hideAnimated:YES afterDelay:hideTime];
}

+ (void)showQuickTipWithTitle:(NSString *)title withText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow]
                                              animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.label.text = title;
    hud.detailsLabel.text = text;
    double hideTime = 0.0;
    if (text.length < 10) {
        hideTime = 1.0f;
    }else if (text.length < 20){
        hideTime = 2.0f;
    }else{
        hideTime = 3.0f;
    }
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = kUIColorFromRGBAlpha(0x000000, 0.7);
    [hud hideAnimated:YES afterDelay:hideTime];
    hud.contentColor = GC.CWhite;
}

+ (void)showWaitingHUDInKeyWindow
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow
                         animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = kUIColorFromRGBAlpha(0x000000, 0.7);
    hud.contentColor = GC.CWhite;
    
}

+ (void)hideAllWaitingHUDInKeyWindow;
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow
                         animated:YES];
}

+ (void)showWaitingHUDInView:(UIView*)view text:(NSString *)text
{
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the label text.
    if (text) {
        hud.label.text = text;
    }else{
        hud.label.text = NSLocalizedString(ML(@"加载中..."), @"HUD loading title");
    }
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = kUIColorFromRGBAlpha(0x000000, 0.7);
    hud.contentColor = GC.CWhite;
}



+ (MBProgressHUD *)showWaitingHUDInView:(UIView *)view;
{
    MBProgressHUD *hud = ([MBProgressHUD showHUDAddedTo:view animated:NO]);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = kUIColorFromRGBAlpha(0x000000, 0.7);
    hud.contentColor = GC.CWhite;
    return hud;
}

+ (void)hideAllWaitingHudInView:(UIView *)view;
{
    [MBProgressHUD hideHUDForView:view animated:NO];
}


+ (void)showTipsWithHUD:(NSString *)labelText
               showTime:(CGFloat)time
              usingView:(UIView *)view
{
    [[self class] showTipsWithHUD:labelText showTime:time usingView:view yOffset:0.0f];
}

+ (void)showTipsWithHUD:(NSString *)labelText
               showTime:(CGFloat)time
              usingView:(UIView *)view
                yOffset:(CGFloat)yOffset
{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
    hud.yOffset = yOffset;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = labelText;
    hud.label.font = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    [view addSubview:hud];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = kUIColorFromRGBAlpha(0x000000, 0.7);
    hud.contentColor = GC.CWhite;
    
    [hud hideAnimated:YES afterDelay:time];
    
}

+ (void)showTipsWithHUD:(NSString *)labelText
               showTime:(CGFloat)time
           withFontSize:(CGFloat)fontSize
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:[[[UIApplication sharedApplication] delegate] window]];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = labelText;
    hud.label.font = [UIFont systemFontOfSize:fontSize];
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    hud.bezelView.backgroundColor = kUIColorFromRGBAlpha(0x000000, 0.7);
    hud.contentColor = GC.CWhite;
    
    [hud hideAnimated:YES afterDelay:time];
}

+ (MBProgressHUD *)showTipsWithHUD:(NSString *)labelText
                          showTime:(CGFloat)time
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:[[[UIApplication sharedApplication] delegate] window]];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = labelText;
    hud.label.font = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = kUIColorFromRGBAlpha(0x000000, 0.7);
    
    [hud hideAnimated:YES afterDelay:time];
    return hud;
}

+(MBProgressHUD *)showCustomHUDViewTo:(UIView*)view TipMsg:(NSString*)msg animated:(BOOL)animated{ //自定义提示框（登录、注册、修改密码成功时提示）
    UIView* customViews = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    //customViews.backgroundColor = [UIColor redColor];
    UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake((customViews.bounds.size.width - 40)/2.0,-10,40, 40)];
    imageV.image = [UIImage imageNamed:@"icon_TipImage"];
    [customViews addSubview:imageV];
    UILabel* tipLab = [[UILabel alloc]initWithFrame:CGRectMake(-20, CGRectGetMaxY(imageV.frame)+2, customViews.bounds.size.width*2, 21)];
    tipLab.text = msg;
    tipLab.backgroundColor = [UIColor clearColor];
    tipLab.textColor = [UIColor whiteColor];
    tipLab.font = [UIFont systemFontOfSize:12];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [customViews addSubview:tipLab];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customViews;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = kUIColorFromRGBAlpha(0x000000, 0.7);
    return hud;
}

@end
