//
//  DQKSectionViewCell.m
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "DQKSectionViewCell.h"

#import <IOSKit/GeneralConfig.h>

@interface DQKSectionViewCell (){
    UIView *leftLine;
    UIView *rightLine;
    UIView *bottomLine;
    UILabel *titleLab;
    
    UIImageView *imgLogo;
}

@end

@implementation DQKSectionViewCell

- (instancetype)initWithStyle:(DQKSectionViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        imgLogo = nil;
        
        _reuseIdentifier = reuseIdentifier;
        [self addTarget:self action:@selector(sectionToDo) forControlEvents:UIControlEventTouchUpInside];
        [self addLine];
        switch (style) {
            case DQKSectionViewCellStyleDefault:
            {
                _style = style;
                titleLab = [[UILabel alloc] init];
                titleLab.textAlignment = NSTextAlignmentCenter;
                titleLab.numberOfLines = 2;
                titleLab.font = [UIFont boldSystemFontOfSize:15];
                [self addSubview:titleLab];
                
                
            }
                break;
            case DQKSectionViewCellStyleCustom:
            {
                _style = style;
            }
            default:
                break;
        }
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLab.text = title;
}

- (void)setTitleColor:(UIColor *)col
{
    [titleLab setTextColor:col];
}

- (void)setDownIcon:(UIImage *)dIcon {
    if (imgLogo) {
        [imgLogo removeFromSuperview];
        imgLogo = nil;
    }
    if (dIcon) {
        imgLogo = [[UIImageView alloc] initWithImage:dIcon];
        [self addSubview:imgLogo];
    }
    
}

- (void)setSeparatorStyle:(DQKSectionViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    if (separatorStyle == DQKSectionViewCellSeparatorStyleNone) {
        [self removeLine];
    }
}

- (void)addLine {
    UIColor *lineGrayColor = [UIColor clearColor];
//    UIColor *lineGrayColor = kUIColorFromRGB(0xD9D9D9);
    leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    leftLine.backgroundColor = lineGrayColor;
    [self addSubview:leftLine];
    rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    rightLine.backgroundColor = lineGrayColor;
    [self addSubview:rightLine];
    bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    bottomLine.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomLine];
}

- (void)setLineGoodsDetailType
{
    leftLine.backgroundColor = kUIColorFromRGB(0xD9D9D9);
    rightLine.backgroundColor = kUIColorFromRGB(0xD9D9D9);
}

- (void)removeLine {
    [leftLine removeFromSuperview];
    [rightLine removeFromSuperview];
    [bottomLine removeFromSuperview];
}

- (void)setLine {
    [leftLine setFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    [rightLine setFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    [bottomLine setFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (self.style == DQKSectionViewCellStyleDefault) {
        [titleLab setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [imgLogo setFrame:CGRectMake((self.frame.size.width - 20)/2, self.frame.size.height - 20, 20, 20)];
    }
    if (self.separatorStyle == DQKSectionViewCellSeparatorStyleSingleLine) {
        [self setLine];
    }
}

//////////////////////// 事件
- (void)sectionToDo{
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(touchSection:)]) {
        [_cellDelegate touchSection:self];
    }
}

@end
