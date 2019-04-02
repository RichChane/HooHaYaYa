//
//  GeneralTooltip.h
//  ZYYObjcLib
//
//  Created by zyyuann on 15/12/30.
//  Copyright © 2015年 ZYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralTooltip : NSObject

+ (GeneralTooltip *)WaitBox;

- (void)setBottomBox:(UIView *)window;
- (void)showBox;
- (void)hiddenBox;

#pragma mark - 提示框

/**
 弹框提示

 @param mes 提示信息
 @param v_cont 所属 UIViewController（空则自动获取）
 */
+ (void)AddAlertView:(NSString *)mes Controll:(UIViewController *)v_cont;
//+ (void)AddDebugAlertView:(NSString *)mes Controll:(UIViewController *)v_cont;   // 调试模式

/**
 弹框提示

 @param mes 提示信息
 @param v_cont 所属 UIViewController（空则自动获取）
 @param endToDo 确认后，要回调执行的事务
 */
+ (void)AddAlertView:(NSString *)mes Controll:(UIViewController *)v_cont EndDo:(void(^)(void))endToDo;

/**
 多选框 选择

 @param title 标题
 @param mes 内容
 @param v_cont 所属 UIViewController（空则自动获取）
 @param strArr NSString型数组
 @param style 弹框类型
 @param endToDo 回调选中的那一项进行回调
 */
+ (void)AddAlertViewTitle:(NSString *)title MSG:(NSString *)mes Controll:(UIViewController *)v_cont ButtonArr:(NSArray *)strArr Style:(UIAlertControllerStyle)style EndDo:(void(^)(NSString *))endToDo;

/**
 加载定时提醒框 （3秒）

 @param supView 要加载的视图
 @param proStr 提示语
 */
+ (void)AddPromptView:(UIView *)supView PromptStr:(NSString *)proStr;

@end
