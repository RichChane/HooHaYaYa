//
//  RadioSelect.h
//  kp
//
//  Created by zhang yyuan on 2017/5/23.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadioSelectDelegate <NSObject>

//必须实现
@required

/**
 返回操作结果
 
 @param typeData 选中数据
 @param isSame 是否重复点击
 */
- (void)radioSelectData:(id)typeData Same:(BOOL)isSame;

@end

@interface RadioSelect : UIView

/**
 初始化界面
 
 @param frame 视图大小
 @param showData 一个存储 NSString 数组
 @param delegate 回调代理
 @return 返回 UIView
 */
- (instancetype)initWithFrame:(CGRect)frame ShowData:(NSArray *)showData Delegate:(id<RadioSelectDelegate>)delegate;

- (void)setButtonIndex:(NSInteger)index;

@end
