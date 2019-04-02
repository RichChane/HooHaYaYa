//
//  DashLine.m
//  PreciousMetal
//
//  Created by DemoLi on 16/10/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "DashLine.h"
#import "GeneralConfig.h"

@implementation DashLine

- (void)setDashLineWithWidth:(CGFloat)width
{
    [self setDashLineWithFrame:CGRectMake(0, 0, width, 1)];
    
}

- (void)setDashLineWithFrame:(CGRect)frame
{
    self.frame = frame;
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, kUIColorFromRGB(0x888).CGColor);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, 1);
    //设置虚线绘制起点
    CGContextMoveToPoint(currentContext, 0, 0);
    //设置虚线绘制终点
    CGContextAddLineToPoint(currentContext, frame.size.width, 0);
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {3, 1};
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    //画线
    CGContextDrawPath(currentContext, kCGPathStroke);
    
}


- (void)drawRect:(CGRect)rect
{
    CGFloat lineLength = 3;
    CGFloat lineSpacing = 3;
    
    if (_isVertical) {//竖线
        // Drawing code
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGContextSetLineWidth(context,1);
        CGContextSetStrokeColorWithColor(context, kUIColorFromRGB(0x888888).CGColor);
        CGFloat lengths[] = {lineLength,lineSpacing};
        CGContextSetLineDash(context, 0, lengths,2);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, 0,rect.size.height);
        CGContextStrokePath(context);
        CGContextClosePath(context);
        
    }else if (!_isVertical){//横线
        
        CGFloat lineLength = 3;
        CGFloat lineSpacing = 3;
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        CGPoint startPoint = CGPointMake(0, 0);
        UIColor *lineColor = kUIColorFromRGB(0x888888);
        //    [shapeLayer setBounds:self.bounds];
        [shapeLayer setPosition:startPoint];
        [shapeLayer setFillColor:[UIColor clearColor].CGColor];
        //  设置虚线颜色为blackColor
        [shapeLayer setStrokeColor:lineColor.CGColor];
        //  设置虚线宽度
        [shapeLayer setLineWidth:OnePX];
        [shapeLayer setLineJoin:kCALineJoinRound];
        //  设置线宽，线间距
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
        //  设置路径
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
        if (_isVertical) {
            CGPathAddLineToPoint(path, NULL,0, rect.size.height);
        }else if (!_isVertical){
            CGPathAddLineToPoint(path, NULL,rect.size.width, 0);
        }
        
        [shapeLayer setPath:path];
        CGPathRelease(path);
        //  把绘制好的虚线添加上来
        [self.layer addSublayer:shapeLayer];
    }
    
    
    
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    //设置虚线颜色
//    CGContextSetStrokeColorWithColor(currentContext, kUIColorFromRGB(0x888888).CGColor);
//    //设置虚线宽度
//    CGContextSetLineWidth(currentContext, 5);
//    //设置虚线绘制起点
//    CGContextMoveToPoint(currentContext, 0, 0);
//    //设置虚线绘制终点
//    CGContextAddLineToPoint(currentContext, rect.size.width, 0);
//    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
//    CGFloat arr[] = {3, 1};
//    //下面最后一个参数“2”代表排列的个数。
//    CGContextSetLineDash(currentContext, 0, arr, 2);
//    //画线
//    CGContextDrawPath(currentContext, kCGPathStroke);
    
    
}


@end
