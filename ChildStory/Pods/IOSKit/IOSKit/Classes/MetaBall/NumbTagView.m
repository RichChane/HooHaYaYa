//
//  NumbTagView.m
//  ZYYObjcLib
//
//  Created by zyyuann on 16/7/14.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import <IOSKit/NumbTagView.h>

#import <IOSKit/IOSKit.h>

@interface NumbTagView(){
    
}

@end

@implementation NumbTagView

- (instancetype)initWithFrame:(CGRect)frame BackgroundColor:(UIColor *)bColor TextColor:(UIColor *)tColor
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:bColor];
        [self setClipsToBounds:YES];
        [self setTextColor:tColor];
        [self setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

- (void)takeNumb:(NSString *)numbStr Font:(UIFont *)font{
    
    [self setFont:font];
    
    if (!(numbStr && numbStr.integerValue > 0)){
        
        if (numbStr && [numbStr isEqualToString:@"0"]) {
            
            // 等于0的时候显示红点
            [self setText:@""];
            
            UIView * supView = self.superview;
            
            [self setFrame:CGRectMake(supView.width/2 + 9, 9, 8, 8)];
            [self setHidden:NO];
            
        }else {
            [self setText:@""];
            [self setHidden:YES];
        }
    }else{
        if (numbStr.integerValue > 99)
            numbStr = @"99+";
        
        [self setText:numbStr];
        
        CGRect labFrame = self.frame;
        labFrame.size.width = 60;
        [GeneralUIUse AutoCalculationView:self MaxFrame:labFrame];
        
        if ((self.frame.size.width + 6) < labFrame.size.height) {
            labFrame.size.width = labFrame.size.height;
        }else{
            labFrame.size.width = self.frame.size.width + 8;
        }
        
        [self setFrame:labFrame];
        
        [self setHidden:NO];
    }
    
    [self.layer setCornerRadius:self.frame.size.height/2];
    [self.layer setBorderColor:self.backgroundColor.CGColor];
    [self.layer setBorderWidth:0.0];
}

@end
