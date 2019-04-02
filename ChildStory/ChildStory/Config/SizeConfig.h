//
//  SizeConfig.h
//  ifangchou
//
//  Created by Rich on 15/11/24.
//  Copyright © 2015年 ifangchou. All rights reserved.
//

#ifndef FCSizeConfig_h
#define FCSizeConfig_h


//size
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define NaviHeight GC.navBarHeight //导航栏高度
#define StatusBarHeight GC.topBarNormalHeight //状态栏高度
#define NaviAndStatusHeight (NaviHeight + StatusBarHeight)
#define MainViewFrameForCustomNavi  CGRectMake(0, NaviAndStatusHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NaviAndStatusHeight)
#define MainViewFrameDistance10  CGRectMake(0, NaviAndStatusHeight+10, SCREEN_WIDTH, SCREEN_HEIGHT - NaviAndStatusHeight-10)

#define OnePX 1.0f/[UIScreen mainScreen].scale
#define ScreenScale [UIScreen mainScreen].scale
#define ToAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

//#define TabBarHeight ((RCTabBarController*)[[UIApplication sharedApplication].delegate window].rootViewController).tabBar.size.height

#define dis_LEFTSCREEN 15
#define dis_RIGHTSCREEN 15
#define dis_TOP 15
#define EditLineHeight 60

#define AvatorRadius 4

// 自定义键盘高度
#define KeyBoardCustomHeight ASIZE(236)

//#define right_Dis 10
//#define left_Dis 10
//#define top_Dis 10
//#define bottom_Dis 10


#endif /* FCSizeConfig_h */
