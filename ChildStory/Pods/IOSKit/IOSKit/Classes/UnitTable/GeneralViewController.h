//
//  GeneralViewController.h
//  ZYYObjcLib
//
//  Created by zyyuann on 15/12/29.
//  Copyright © 2015年 ZYY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <IOSKit/CustomNavView.h>

@interface GeneralViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    UIBarButtonItem *right1;
    UIBarButtonItem *right2;
    UIBarButtonItem *right3;
    
    CGRect viewFrame;
    
    BOOL openObserver;
}

@property (nonatomic, copy) NSString * customTitleStr;

@property (nonatomic, strong) NSDictionary *publicDic;

@property (nonatomic, strong) id publicData;

@property (nonatomic, strong, readonly) CustomNavView *customNavBar;

@property BOOL needBar;
@property NSInteger typeBar;        // bar 模式

@property BOOL unNeedNav;
@property BOOL isSelfNav;       // 是否使用自定义nav
@property BOOL unGestureRecognizer;

@property BOOL needReload;

@property BOOL openFrameReload;     // 是否根据frame变更进行刷新

- (id)initWithViewFrame:(CGRect)frame;         // 以指定宽度初始化

/**
 导航条 设置
 
 @param barColor navBar 背景颜色
 @param aColor 标题颜色，同时会影响按钮颜色
 @param isWhite 顶部状态栏是否显示白色
 */
- (void)navigationBarColor:(UIColor *)barColor TextAttributes:(UIColor *)aColor Style:(BOOL)isWhite;

/**
 获取self.view可操作界面大小（回根据是否有 navigationBar、tabBar 来计算）
 
 @return 整体大小
 */
- (CGRect)getShowScreen;

/**
 *  @brief 给自定义的UINavigationBar添加中间的title.
 *
 *  @param titleViewItem 中间UIBarButtonItem显示的内容，可以是NSString、UIImage、UIView.
 */
- (void)addCustomNavBarTitleViewItem:(NSObject *)titleViewItem;

/**
 *  @brief 给UINavigationBar添加左边的UIBarButtonItem.
 *
 *  @param barButtonItem 左边UIBarButtonItem显示的内容，可以是NSString、UIImage、UIView.
 */
- (void)addLeftBarButtonItem:(NSObject *)barButtonItem;
- (void)addLeftBarButtonItem:(NSObject *)barButtonItem TintColor:(UIColor *)color;

/**
 *  @brief 给UINavigationBar添加右边的UIBarButtonItem.
 *
 *  @param barButtonItem 左边UIBarButtonItem显示的内容，可以是NSString、UIImage、UIView.
 */
- (void)addRightBarButtonItem:(NSObject *)barButtonItem;
- (void)addRightBarButtonItem:(NSObject *)barButtonItem TintColor:(UIColor *)color;

- (void)addRight2ButtonItem:(NSObject *)rightButtonItem;
- (void)addRight3ButtonItem:(NSObject *)rightButtonItem;

/**     @note 应该由子类重写该方法.
 *
 *  @brief navigation bar上左边的bar button item被点击后回调.
 *
 *  @param barButtonItem 当前的UIBarButtonItem对象.
 */
- (void)leftBarButtonItemClicked:(UIBarButtonItem *)barButtonItem;
- (void)left2ButtonItemClicked:(UIButton *)barButtonItem;
- (void)left3ButtonItemClicked:(UIButton *)barButtonItem;

/**     @note 应该由子类重写该方法.
 *
 *  @brief navigation bar上右边的bar button item被点击后回调.
 *
 *  @param barButtonItem 当前的UIBarButtonItem对象.
 */
- (void)rightBarButtonItemClicked:(UIBarButtonItem *)barButtonItem;
- (void)right2ButtonItemClicked:(UIButton *)barButtonItem;
- (void)right3ButtonItemClicked:(UIButton *)barButtonItem;

/**
 接收消息   @note 应该由子类重写该方法.
 
 @param msg 消息
 */
- (void)receiveMessage:(id)msg;

/**
 （备用）
 *
 *
 */
- (void)refreshController;

// 对出栈进行回调用（废弃）
- (void)viewControllerDidPopFromNavigationController;


/**
 *
 *  @brief 获取Navigation上子视图
 *
 *  @param 1140 --> right2
 *  @param 1150 --> right3
 */
- (UIView *)viewInNaviWithTag:(NSInteger)tag;



@end

