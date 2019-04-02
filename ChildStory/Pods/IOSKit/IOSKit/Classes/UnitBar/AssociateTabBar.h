//
//  AssociateTabBar.h
//  ZYY
//
//  Created by zyy_pro on 14-6-23.
//  Copyright (c) 2014年 zyy. All rights reserved.
//  侧边栏，同步底部导航

#import <UIKit/UIKit.h>

#import <IOSKit/TabBarDelegate.h>

#define MAXPOINT     10

#define TabBarSide     @"TabBar_Side"

@interface AssociateTabBar : UIView{
    id<TabBarDelegate> delegate;
    UIView *newPoint[MAXPOINT];
}

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray Delegate:(id<TabBarDelegate>)theDelega;

- (void)setToNewPoint:(NSInteger)which IsHid:(BOOL)toHid;

@end
