//
//  UIView+changeColor.h
//  kp
//
//  Created by Kevin on 2018/2/24.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (changeColor)

/**
 绘制渐变色
 
 @param beginColor 起始颜色
 @param endColor 终止颜色值
 @param startpoint 起始位置 {0,0}表示左上角，{1,1}表示左下角  数值必须在0~1之间
 @param endPoint 终止位置 {0,0}表示左上角，{1,1}表示左下角   数值必须在0~1之间
 */
- (void)setBeginColor:(UIColor *)beginColor endColor:(UIColor*)endColor StartPoint:(CGPoint)startpoint EndPoint:(CGPoint)endPoint;
- (void)setDefaultChangeColor;

@end
