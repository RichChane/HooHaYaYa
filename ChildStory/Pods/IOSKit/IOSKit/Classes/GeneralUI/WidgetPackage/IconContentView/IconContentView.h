//
//  IconContentView.h
//  kp
//
//  Created by gzkp on 2017/5/18.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconContentView : UIControl

@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *postfixLabel;
@property (nonatomic,strong) UIImageView *iconImV;

+ (IconContentView*)createViewWithImage:(UIImage*)image content:(NSString *)content contentColor:(UIColor*)contentColor contentFont:(UIFont *)contentFont;

+ (IconContentView*)createViewWithImage:(UIImage*)image content:(NSString *)content contentColor:(UIColor*)contentColor;

- (void)setContent:(NSString*)content postfix:(NSString*)postfix;

@end
