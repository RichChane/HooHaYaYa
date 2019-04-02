//
//  KPStackedContainerViewController.h
//  ViewStack
//
//  Created by lkr on 2018/4/3.
//  Copyright © 2018年 lkr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <IOSKit/GeneralViewController.h>

/// 当前界面层的VC，主要管理左右两边拥有navigation的VC
@interface DoubleNavController : GeneralViewController

@property (nonatomic, strong, readonly) UINavigationController * leftViewController;
@property (nonatomic, strong, readonly) UINavigationController * rightViewController;

/**
 视图容器的唯一初始化方法

 @param leftViewController 左边的视图 必传
 @param rightViewController 右边的视图 可为空，为空时整个界面都是leftViewController
 @return 返回本类
 */
- (BOOL)addLeftViewController:(UINavigationController *)lController RightViewController:(UINavigationController *)rController;

/**
 切换右边的视图  一般是通过点击左边的按钮触发更换右边的视图
 
 @param rightViewController 要替换的右边视图
 */
- (void)changeRightViewController:(UINavigationController *)rController;

@end
