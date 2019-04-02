//
//  CustomNaviView.h
//  ViewStackOtherCase
//
//  Created by lkr on 2018/4/8.
//  Copyright © 2018年 lkr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationItem.h"

typedef NS_ENUM (NSInteger,CustomNavButtonType)  {
    CustomNavButtonTypeFree = 0,
    
    CustomNavButtonTypeLeft = 1,
    
    CustomNavButtonTypeLeft_2 ,
    
    CustomNavButtonTypeLeft_3 ,
    
    
    CustomNavButtonTypeRight = 10,
    
    CustomNavButtonTypeRight_2 ,
    
    CustomNavButtonTypeRight_3 ,
    
    CustomNavButtonTypeMiddle = 20
};


/// 自定义导航栏
@interface CustomNavView : UIView

/// 标题
@property (nonatomic, copy) NSString * customTitle;

@property (nonatomic, strong, readonly) UIColor *defColor;          // 默认 字体、按钮 颜色

@property (nonatomic, strong) UIView * customView;          // 用于 搜索，高于 title, 会根据按钮的多少来变化位置

- (id)initWithWidth:(CGFloat)width Height:(CGFloat)height;

- (void)buttonWithView:(UIView *)bView Type:(CustomNavButtonType)type;
// 生成中间的控件
- (void)titleWithViewItem:(NSObject *)viewItem Type:(CustomNavButtonType)type;

- (void)setAttributesWithColor:(UIColor *)color;

@end
