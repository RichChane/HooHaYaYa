//
//  DashLine.h
//  PreciousMetal
//
//  Created by DemoLi on 16/10/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashLine : UIView

@property (nonatomic,assign) BOOL isVertical;//是否是竖线

- (void)setDashLineWithWidth:(CGFloat)width;

- (void)setDashLineWithFrame:(CGRect)frame;

@end
