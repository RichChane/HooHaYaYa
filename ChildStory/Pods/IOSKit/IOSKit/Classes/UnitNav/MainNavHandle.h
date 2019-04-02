//
//  MainHandle.h
//  ZYYObjcLib
//
//  Created by zyyuann on 16/2/20.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainNavHandle : NSObject

+ (MainNavHandle *)Share;

@property(strong, nonatomic, readonly) UINavigationController *navController;         // 主 nav

/**
 初始化 注nav

 */
- (id)initBaseNavBar;

/**
 释放 主tabbar
 */
- (void)deallocMain;



/**
 添加两个 NavController

 @param setting 配置文件
 */
- (void)addLeftRightNavControllerSetting:(NSString *)setting;

/**
 push两个 NavController
 
 @param setting 配置文件
 @param rTag 对应配置文件右边下标
 @param lTag 指定配置文件左边下标
 
 */
- (void)pushLeftRightNavControllerSetting:(NSString *)setting RightTag:(NSInteger)rTag;
- (void)pushLeftRightNavControllerSetting:(NSString *)setting LeftTag:(NSInteger)lTag RightTag:(NSInteger)rTag;

- (void)changehLeftRightNavControllerSetting:(NSString *)setting RightTag:(NSInteger)rTag;


/**
 对当前左右vc传数据

 @param msg 数据
 */
- (void)sendToRightNavMessage:(id)msg;
- (void)sendToLeftNavMessage:(id)msg;

@end
