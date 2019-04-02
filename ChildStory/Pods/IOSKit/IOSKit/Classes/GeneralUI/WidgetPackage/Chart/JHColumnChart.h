//
//  JHColumnChart.h
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/5/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHChart.h"

@protocol JHColumnChartDelegate <NSObject>

//必须实现
@required

/**
 刷新数据
 
 @param tag 选中项，以0开头
 @param point 选中位置
 */
- (void)selectColumnTag:(NSInteger)tag Point:(CGPoint)point;

@end

@interface JHColumnChart : JHChart


@property (nonatomic, weak) id<JHColumnChartDelegate> columnChartDelegate;

/**
 *  Each histogram of the background color, if you do not set the default value for green. Setup must ensure that the number and type of the data source array are the same, otherwise the default is not set.
    每条柱的颜色 要以 valueArr每项数量 成一致
 */
@property (nonatomic, strong) NSArray<NSArray *> * columnBGcolorsArr;

/**
 *  Data source array
    数据源，数组每项是数组直
 */
@property (nonatomic, strong) NSArray<NSArray *> * valueArr;

/**
 *  X axis classification of each icon
    X 轴 描述
 */
@property (nonatomic, strong) NSArray * xShowInfoText;


/**
 *  The background color of the content view
 */
@property (nonatomic, strong) UIColor  * bgVewBackgoundColor;


/**
 *  Column spacing, non continuous, default is 5
    俩个数据间的间隔
 */
@property (nonatomic, assign) CGFloat typeSpace;

/**
 *  The width of the column, the default is 30
    线条宽度
 */
@property (nonatomic, assign) CGFloat columnWidth;

/**
 *  Whether the need for Y, X axis, the default YES
 */
@property (nonatomic, assign) BOOL needXandYLine;

/**
 *  Y, X axis line color
 */
@property (nonatomic, strong) UIColor * colorForXYLine;

/**
 *  X, Y axis text description color
    X、Y 轴 数据 的颜色
 */
@property (nonatomic, strong) UIColor * drawTextColorForX_Y;

/**
 *  Dotted line guide color
 */
@property (nonatomic, strong) UIColor * dashColor;

/**
 *  The starting point, can be understood as the origin of the left and bottom margins
    左下角开始绘制的点
 */
@property (nonatomic, assign) CGPoint originSize;

/**
 *  Starting from the origin of the horizontal distance histogram
    绘图延X轴偏移量 (开始绘制)
 */
@property (nonatomic, assign) CGFloat drawFromOriginX;

/**
 *  Whether this chart show Y line or not .Default is Yes
 */
@property (nonatomic,assign) BOOL isShowYLine;

/**
 *  Whether this chart show line or not.Default is NO;
 */
@property (nonatomic,assign) BOOL isShowLineChart;

/**
 *  是否串行排列.Default is NO;
 */
@property (nonatomic,assign) BOOL isColumnSerial;


/**
 *  If isShowLineChart proprety is YES,we need this value array to draw chart
 */
@property (nonatomic,strong)NSArray * lineValueArray;


/**
 *  If isShowLineChart proprety is Yes,we will draw path of this linechart with this color
 *  Default is blue
 */
@property (nonatomic,strong)UIColor * lineChartPathColor;

/**
 *  if isShowLineChart proprety is Yes,we will draw this linechart valuepoint with this color
 *  Default is yellow
 */
@property (nonatomic,strong)UIColor * lineChartValuePointColor;


@end
