//
//  MainHandle.h
//  ZYYObjcLib
//
//  Created by zyyuann on 16/2/20.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BallDelAll)(void);

@interface MainHandle : NSObject{
    
}

+ (MainHandle *)Share;

@property (nonatomic, copy) BallDelAll ballBack;


#pragma mark - tabbar为主导框架，使用到 tabbar 的时候

/**
 初始化 与 刷新TabBar
 
 @param isMain 是否主页
 @param suffix 配置文件
 @return 返回 ViewController
 */
- (id)initTabBarWithSuffix:(NSString *)suffix Main:(BOOL)isMain;

/**
 释放 主tabbar
 */
- (void)deallocMain;

/**
 展示TabBarController
 
 @param isAnimate 是否渐变展示
 */
- (void)showBarAnimate:(BOOL)isAnimate;

/**
 展示TabBarController  运行时修改tabbar（未用）
 
 @param tag 第几项
 @param suffix 后缀（读配置文件的后缀）
 */
- (void)reloadBarSuffix:(NSString *)suffix Tag:(NSInteger)tag;

/**
 隐藏或展示bar（不建议使用）
 
 @param hide 是否隐藏
 */
- (void)isHideBar:(BOOL)hide;

/**
 theView是否存在导航条
 
 type 导航条类型
 
 @return YES 表示存在
 */
- (BOOL)barInView:(UIView *)theView Type:(NSInteger)type;

/**
 设置bar位置
 
 @param theView 要加载的 UIView
 */
- (void)barBuildToView:(UIView *)theView Type:(NSInteger)type;
- (void)upBarBuildToView:(UIView *)theView;
- (UIView *)getBarView:(NSInteger)type;

/**
 代码控制切换TabBar
 
 @param wBar 要显示第几个
 */
- (void)selectWhichBar:(NSInteger)wBar Type:(NSInteger)type;


/**
 设置红点提示（不带数字）
 
 @param which 在第几个tab上显示
 @param toHid 是否隐藏
 */
- (void)setNewPoint:(NSInteger)which IsHid:(BOOL)toHid;

/**
 设置红框数字提示
 
 @param which 在第几个tab上显示
 @param numbStr 提示数据
 @param isCleanAll 是否带上拖动操作，如果是，操作将从代理返回
 */
- (void)setNew:(NSInteger)which Numb:(NSString *)numbStr OpenClean:(BOOL)isCleanAll;

/**
 设置底部tabbar的title
 
 @param which 在第几个tab上显示
 @param titleStr title
 @param imageNor 未选中的图片
 @param imageSelected 选中的图片
 */
- (void)setTitleWithNew:(NSInteger)which TitleStr:(NSString *)titleStr ImageNor:(UIImage *)imageNor ImageSelected:(UIImage *)imageSelected;
/**
 添加红框数字监控(自带移除功能)
 
 @param item 需要被监控的UIView
 */
- (void)addBallMonitor:(id)item;

/**
 获取当前ViewController
 
 @return 当前ViewController
 */
- (id)getNowViewController;
/**
 获取当前屏幕显示的viewcontroller
 
 @return ViewController
 */
- (id)getShowViewController;

@end
