//
//  Proress.h
//  TestDemo
//
//  Created by kiwo on 16/8/9.
//  Copyright © 2016年 kiwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Proress : NSObject

+ (Proress *)sharedInstance;

//显示进度与百分比
-(void)show;

//显示进度，百分比与状态
-(void)showText:(NSString *)text;

/**
 *  使用该方法之前一定需要调用show 或者 showText
 *
 *  @param proress 0~1
 */
-(void)setProress:(CGFloat)proress;
//移除
-(void)dismiss;

@end
