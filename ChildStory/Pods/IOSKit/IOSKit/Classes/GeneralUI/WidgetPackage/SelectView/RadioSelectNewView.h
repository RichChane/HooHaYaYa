//
//  RadioSelectNewView.h
//  kp
//
//  Created by lkr on 2018/8/8.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadioSelectNewViewDelegate <NSObject>

//必须实现
@required

/**
 返回操作结果
 
 @param typeData 选中数据
 @param isSame 是否重复点击
 */
- (void)radioSelectNewViewData:(id)typeData Same:(BOOL)isSame;

@end

@interface RadioSelectNewView : UIView

/**
 初始化界面
 
 @param frame 视图大小
 @param showData 一个存储 NSString 数组
 @param space 间距
 @param delegate 回调代理
 @return 返回 UIView
 */
- (instancetype)initWithFrame:(CGRect)frame ShowData:(NSArray *)showData AndSpacing:(CGFloat)space Delegate:(id<RadioSelectNewViewDelegate>)delegate;

- (void)setButtonIndex:(NSInteger)index;

@end
