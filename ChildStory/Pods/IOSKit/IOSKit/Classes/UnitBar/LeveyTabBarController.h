//
//  LeveyTabBarControllerViewController.h
//  LeveyTabBarController
//
//  Created by zhang on 12-10-10.
//  Copyright (c) 2012年 jclt. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <IOSKit/LeveyTabBar.h>
#import <IOSKit/AssociateTabBar.h>

#import <IOSKit/GeneralViewController.h>

#import <IOSKit/MetaBallCanvas.h>

@protocol LeveyTabBarControllerDelegate;

@interface LeveyTabBarController : GeneralViewController <TabBarDelegate>
{
    MetaBallCanvas *ballView;
    
    NSMutableArray *viewControllers;     // 导航对应 Controller
    
    NSInteger lastIndex;
	
    NSInteger animateDriect;        // 底部重复按下次数
    
    UIButton *hidSideBtn;
    
}

@property(nonatomic) NSUInteger selectIndex;  // 当前选中 Index

@property(nonatomic, readonly) GeneralViewController *selectedNowController;    // 当前选中 Controller
@property (nonatomic, readonly) LeveyTabBar *myTabBar;      // 自定义底部导航条

@property (nonatomic, readonly) AssociateTabBar *sideBar;         // 自定义侧边栏
@property (assign, nonatomic) SEL side_Bar;

/**
 初始化 （vcs数量 = b_arr数量）
 
 @param vcs GeneralViewController 数组
 @param bArr图片数组
 @param img TabBar背景图
 @return 是否成功
 */
- (id)initWithViewControllers:(NSArray *)vcs BarImage:(NSArray *)bArr BarBgImage:(UIImage *)img;

/**
 是否隐藏导航条

 @param yesOrNO 是否隐藏
 @param animated 是否需要动画
 */
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;

/**
 删除一项导航（待测）

 @param index 要删除的一项
 */
- (void)removeViewControllerAtIndex:(NSUInteger)index;

- (void)removeAllController;

/**
 返回上个tabBar界面
 */
- (void)backLastIndex;

/**
 创建红点基试图
 */
- (void)bulidBallView;

@end

