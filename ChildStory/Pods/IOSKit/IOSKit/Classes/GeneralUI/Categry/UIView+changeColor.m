//
//  UIView+changeColor.m
//  kp
//
//  Created by Kevin on 2018/2/24.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "UIView+changeColor.h"
#import "GeneralConfig.h"

@implementation UIView (changeColor)

- (void)setDefaultChangeColor
{
    [self setBeginColor:kUIColorFromRGB(0xFC9F06) endColor:kUIColorFromRGB(0xFC9F06) StartPoint:CGPointMake(0, 0.5) EndPoint:CGPointMake(1, 0.5)];
}

- (void)setBeginColor:(UIColor *)beginColor endColor:(UIColor*)endColor StartPoint:(CGPoint)startpoint EndPoint:(CGPoint)endPoint
{
    //创建CGContextRef
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = self.bounds;
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    
    //绘制渐变
    [self drawLinearGradient:gc path:path startColor:beginColor.CGColor endColor:endColor.CGColor StartPoint:startpoint EndPoint:endPoint];
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if([self isKindOfClass:[UIButton class]]){
        [(UIButton *)self setBackgroundImage:img forState:UIControlStateNormal];
        [(UIButton *)self setBackgroundImage:img forState:UIControlStateHighlighted];
        return;
    }
    if([self isKindOfClass:[UISwitch class]]){
        [(UISwitch *)self setOnTintColor:[UIColor colorWithPatternImage:img]];
        return;
    }
    
    self.backgroundColor = [UIColor colorWithPatternImage:img];
}

- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
                StartPoint:(CGPoint)startpoint
                  EndPoint:(CGPoint)endPoint
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint sPoint = CGPointMake(CGRectGetMinX(pathRect) + CGRectGetWidth(pathRect) * startpoint.x, CGRectGetMinY(pathRect) + CGRectGetHeight(pathRect) * startpoint.y);
    CGPoint ePoint = CGPointMake(CGRectGetMinX(pathRect) + CGRectGetWidth(pathRect) * endPoint.x, CGRectGetMinY(pathRect) + CGRectGetHeight(pathRect) * endPoint.y);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, sPoint, ePoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
@end
