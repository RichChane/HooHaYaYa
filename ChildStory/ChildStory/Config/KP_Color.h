//
//  KP_Color.h
//  kpkd
//
//  Created by gzkp on 2018/2/10.
//  Copyright © 2018年 kptech. All rights reserved.
//

#ifndef KP_Color_h
#define KP_Color_h

#define KP_APP_TYPE 2


#if KP_APP_TYPE == 0

#define C_1 kUIColorFromRGBAlpha(0xFF9F00, 1)       //一级导航栏
#define C_2 kUIColorFromRGBAlpha(0x000000, 0.9)     //一级标题
#define C_3 kUIColorFromRGBAlpha(0x000000, 0.5)     //二级标题
#define C_4 kUIColorFromRGBAlpha(0x000000, 0.3)     //动态密码
#define C_5 kUIColorFromRGBAlpha(0xE64340, 1)       //欠款警示色
#define C_6 kUIColorFromRGBAlpha(0xE64340, 1)       //删除警示色
#define C_7 kUIColorFromRGBAlpha(0xEFEFF4, 1)       //页面背景色
#define C_8 kUIColorFromRGBAlpha(0x000000, 0.1)     //线条颜色
#define C_9 kUIColorFromRGBAlpha(0x000000, 0.6)     //半透明背景
#define C_10 kUIColorFromRGBAlpha(0x00AE7C, 1)     //开单器表示余额的绿色

#elif KP_APP_TYPE == 1

#define C_1 kUIColorFromRGBAlpha(0xFF9F00, 1)       //一级导航栏
#define C_2 kUIColorFromRGBAlpha(0x000000, 0.9)     //一级标题
#define C_3 kUIColorFromRGBAlpha(0x000000, 0.5)     //二级标题
#define C_4 kUIColorFromRGBAlpha(0x000000, 0.3)     //动态密码
#define C_5 kUIColorFromRGBAlpha(0xE64340, 1)       //欠款警示色
#define C_6 kUIColorFromRGBAlpha(0xE64340, 1)       //删除警示色
#define C_7 kUIColorFromRGBAlpha(0xEFEFF4, 1)       //页面背景色
#define C_8 kUIColorFromRGBAlpha(0x000000, 0.1)     //线条颜色
#define C_9 kUIColorFromRGBAlpha(0x000000, 0.6)     //半透明背景
#define C_10 kUIColorFromRGBAlpha(0x00AE7C, 1)     //开单器表示余额的绿色

#elif KP_APP_TYPE == 2

#define C_1 kUIColorFromRGBAlpha(0xFF9F00, 1)       //一级导航栏
#define C_2 kUIColorFromRGBAlpha(0x000000, 0.9)     //一级标题
#define C_3 kUIColorFromRGBAlpha(0x000000, 0.5)     //二级标题
#define C_4 kUIColorFromRGBAlpha(0x000000, 0.3)     //动态密码
#define C_5 kUIColorFromRGBAlpha(0xE64340, 1)       //欠款警示色
#define C_6 kUIColorFromRGBAlpha(0xE64340, 1)       //删除警示色
#define C_7 kUIColorFromRGBAlpha(0xEFEFF4, 1)       //页面背景色
#define C_8 kUIColorFromRGBAlpha(0x000000, 0.1)     //线条颜色
#define C_9 kUIColorFromRGBAlpha(0x000000, 0.6)     //半透明背景
#define C_10 kUIColorFromRGBAlpha(0x00AE7C, 1)     //开单器表示余额的绿色
#define fghjgfhj @"1231321311231"


#pragma mark - 以下是KP7.0使用的颜色值
/// 白色
#define C_White kUIColorFromRGBAlpha(0xFFFFFF, 1)
/// 标题色 黑色
#define C_Black_Title kUIColorFromRGBAlpha(0x000000, 1)
/// 描述 深灰色
#define C_Gray_Describe kUIColorFromRGBAlpha(0x7F7F7F, 1)
/// 提示色 浅灰色
#define C_Gray_Remind kUIColorFromRGBAlpha(0xA3A3A3, 1)
/// 线条颜色 再浅灰色
#define C_Gray_Line kUIColorFromRGBAlpha(0xD4D4D4, 1)
/// 背景色 更浅灰色
#define C_Gray_Background kUIColorFromRGBAlpha(0xF5F5F5, 1)

/// 超链接 蓝色
#define C_Blue_Links kUIColorFromRGBAlpha(0x0082FF, 1)
/// 快批黄 黄色
#define C_Yellow_KP kUIColorFromRGBAlpha(0xFC9F06, 1)
/// 价格颜色 黄色
#define C_Yellow_Price kUIColorFromRGBAlpha(0xFF8900, 1)
/// 警示色 红色
#define C_Red_Warn kUIColorFromRGBAlpha(0xEC2121, 1)
/// 微信/欠款  绿色
#define C_Green_owe kUIColorFromRGBAlpha(0x2EB82F, 1)


/// 按钮的三个状态  正常背景色是 快批黄
/// 按钮按下时的背景色
#define C_Yellow_BtnDown kUIColorFromRGBAlpha(0xE28300, 1)
/// 按钮禁用时的背景色
#define C_Yellow_BtnUnable kUIColorFromRGBAlpha(0xFECF83, 1)

#endif





#endif /* KP_Color_h */
