//
//  TabBarDelegate.h
//  CCBShop
//
//  Created by zyy_pro on 14-6-23.
//  Copyright (c) 2014年 CCB. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TabBarDelegate <NSObject>

@optional
- (void)tabBar:(UIView *)tabBar didSelectIndex:(NSInteger)index;

- (void)addBallTag:(UIView *)item;      // 添加红的监控(移除功能)
- (void)cleanAllBall;      // 清除所有红的

@end
