//
//  GeneralTooltip.m
//  ZYYObjcLib
//
//  Created by zyyuann on 15/12/30.
//  Copyright © 2015年 ZYY. All rights reserved.
//

#import "GeneralTooltip.h"

#import "GeneralUIUse.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface GeneralTooltip(){
    
    UIView *bottomView;      // 底座视图
    
    MBProgressHUD *hud;
}

@end

@implementation GeneralTooltip

+ (GeneralTooltip *)WaitBox{
    
    static dispatch_once_t once;
    static GeneralTooltip * singleton;
    
    dispatch_once(&once, ^{ singleton = [[GeneralTooltip alloc] init]; });
    return singleton;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        bottomView = nil;
        hud = nil;
    }
    return self;
}

/////////////////////////////////////
- (void)setBottomBox:(UIView *)window{
    bottomView = window;
    
    if (hud) {
        [hud removeFromSuperview];
        hud = nil;
    }
}

- (void)showBox{
    if (!bottomView) {
        NSAssert(bottomView , @"加载框不能没有底座");
        return;
    }
    
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:bottomView];
        [bottomView addSubview:hud];
        hud.mode = MBProgressHUDModeIndeterminate;         //圆形加载框
        hud.labelText = @"加载中...";
        [hud setRemoveFromSuperViewOnHide:YES];
        hud.dimBackground = YES;
    }
    
    [hud show:YES];
}

- (void)hiddenBox{
    if (hud) {
        [hud hide:NO];
        hud = nil;
    }
    
}

#pragma mark - 提示框
// 只带确定的提醒框
+ (void)AddAlertView:(NSString *)mes Controll:(UIViewController *)v_cont{
    if (!v_cont) {
        v_cont = [GeneralUIUse GetWindowViewController];
        if (!v_cont) {
            return;
        }
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:mes
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                NSLog(@"Action 1 Handler Called");
                                            }]];
    
    [v_cont presentViewController:alert animated:YES completion:nil];
}
//+ (void)AddDebugAlertView:(NSString *)mes Controll:(UIViewController *)v_cont{
//    if (!DEBUG) {
//        return;
//    }
//    
//    if (!v_cont) {
//        v_cont = [GeneralUIUse GetWindowViewController];
//        if (!v_cont) {
//            return;
//        }
//    }
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                   message:mes
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
//                                              style:UIAlertActionStyleDefault
//                                            handler:^(UIAlertAction *action) {
//                                                NSLog(@"Action 1 Handler Called");
//                                            }]];
//    
//    [v_cont presentViewController:alert animated:YES completion:nil];
//}


+ (void)AddAlertView:(NSString *)mes Controll:(UIViewController *)v_cont EndDo:(void(^)(void))endToDo{
    if (!v_cont) {
        v_cont = [GeneralUIUse GetWindowViewController];
        if (!v_cont) {
            return;
        }
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:mes
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                if (endToDo) {
                                                    endToDo();
                                                }
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
                                                
                                            }]];
    
    [v_cont presentViewController:alert animated:YES completion:nil];
}

+ (void)AddAlertViewTitle:(NSString *)title MSG:(NSString *)mes Controll:(UIViewController *)v_cont ButtonArr:(NSArray *)strArr Style:(UIAlertControllerStyle)style EndDo:(void(^)(NSString *))endToDo{
    
    if (!(strArr && [strArr count] > 0)) {
        return;
    }
    
    if (!v_cont) {
        v_cont = [GeneralUIUse GetWindowViewController];
        if (!v_cont) {
            return;
        }
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:mes
                                                            preferredStyle:style];
    
    for (NSInteger i = 0; i < [strArr count]; i++) {
        UIAlertActionStyle type = UIAlertActionStyleDefault;
        NSString *oneAction = strArr[i];
        if ([oneAction isEqualToString:@"取消"] || [oneAction isEqualToString:@"关闭"]) {
            type = UIAlertActionStyleCancel;
        }
        
        [alert addAction:[UIAlertAction actionWithTitle:oneAction
                                                  style:type
                                                handler:^(UIAlertAction *action) {
                                                    if (endToDo) {
                                                        endToDo(action.title);
                                                    }
                                                }]];
    }
    
    [v_cont presentViewController:alert animated:YES completion:nil];
}


// 加载定时提醒框
+ (void)AddPromptView:(UIView *)supView PromptStr:(NSString *)proStr{
    UILabel *proLabView = [[UILabel alloc]init];
    [proLabView setAlpha:0];
    [proLabView setBackgroundColor:[UIColor blackColor]];
    [proLabView setTextColor:[UIColor whiteColor]];
    [proLabView setTextAlignment:NSTextAlignmentCenter];
    [proLabView setFont:[UIFont systemFontOfSize:14.0]];
    [proLabView setText:proStr];
    [supView addSubview:proLabView];
    
    [GeneralUIUse AutoCalculationView:proLabView MaxFrame:CGRectMake(0, 0, supView.frame.size.width - 60, 100)];
    
    CGRect proFrame = proLabView.frame;
    proFrame.origin.x = (supView.frame.size.width - proFrame.size.width - 6)/2;
    proFrame.origin.y = supView.frame.size.height - proFrame.size.height - 60;
    proFrame.size.width += 6;
    proFrame.size.height += 10;
    [proLabView setFrame:proFrame];
    
    [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [proLabView setAlpha:1];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              [proLabView setAlpha:0.2];
                                          }
                                          completion:^(BOOL finished){
                                              [proLabView removeFromSuperview];
                                          }
                          
                          ];
                     }
     
     ];
}

@end
