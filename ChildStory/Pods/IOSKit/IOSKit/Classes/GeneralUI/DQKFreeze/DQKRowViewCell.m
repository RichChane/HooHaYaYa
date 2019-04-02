//
//  DQKRowViewCell.m
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "DQKRowViewCell.h"

#import <IOSKit/GeneralConfig.h>

@interface DQKRowViewCell (){
    UIView *bottomLine;
    UIView *topLine;
    
    UIImageView *imgLogo;
}

@end

@implementation DQKRowViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier Edit:(BOOL)isEdit {
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        self.backgroundColor = [UIColor clearColor];
        [self addTarget:self action:@selector(rowToDo) forControlEvents:UIControlEventTouchUpInside];
        
        [self addLine];
        
        imgLogo = nil;
        
        if (isEdit) {
            _titleRowField = [[KPTextField alloc] init];
            _titleRowField.backgroundColor = [UIColor clearColor];
            _titleRowField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _titleRowField.font = [UIFont systemFontOfSize:15];
            [_titleRowField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
            
            [self addSubview:_titleRowField];
            
        } else {
            _titleRowLab = [[UILabel alloc] init];
            _titleRowLab.backgroundColor = [UIColor clearColor];
            _titleRowLab.textAlignment = NSTextAlignmentCenter;
            _titleRowLab.numberOfLines = 2;
            _titleRowLab.font = [UIFont systemFontOfSize:15];
            
            [self addSubview:_titleRowLab];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (_titleRowField) {
        _titleRowField.text = title;
    } else if (_titleRowLab) {
        _titleRowLab.text = title;
    }
    
}

- (void)setRightIcon:(UIImage *)rIcon {
    if (imgLogo) {
        [imgLogo removeFromSuperview];
        imgLogo = nil;
    }
    if (rIcon) {
        imgLogo = [[UIImageView alloc] initWithImage:rIcon];
        [self addSubview:imgLogo];
    }
    
}

- (void)setTitleColor:(UIColor *)col
{
    if (_titleRowField) {
        [_titleRowField setTextColor:col];
    } else if (_titleRowLab) {
        [_titleRowLab setTextColor:col];
    }
    
    
}

- (void)setSeparatorStyle:(DQKRowViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    if (separatorStyle == DQKRowViewCellSeparatorStyleNone) {
        [self removeLine];
    }
}

- (void)addLine {
    UIColor *lineGrayColor = [UIColor clearColor];
//    UIColor *lineGrayColor = kUIColorFromRGB(0xD9D9D9);
    topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    topLine.backgroundColor = lineGrayColor;
    [self addSubview:topLine];
    bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
    bottomLine.backgroundColor = lineGrayColor;
    //[self addSubview:bottomLine];
}

- (void)setLineGoodsDetailType
{
    topLine.backgroundColor = kUIColorFromRGB(0xD9D9D9);
    bottomLine.backgroundColor = kUIColorFromRGB(0xD9D9D9);
}

- (void)removeLine {
    [topLine removeFromSuperview];
    [bottomLine removeFromSuperview];
}

- (void)setLine {
    [topLine setFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    [bottomLine setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
    //[self setLineGoodsDetailType];
}

- (void)setUpDownLine:(BOOL)isShowLine {
    
    if (isShowLine && self.separatorStyle == DQKRowViewCellSeparatorStyleSingleLine) {
        [self setLineGoodsDetailType];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_moveTitleType == 0) {
        if (_titleRowField) {
            _titleRowField.textAlignment = NSTextAlignmentCenter;
            [_titleRowField setFrame:CGRectMake(_moveTitleSize, 0, self.frame.size.width - _moveTitleSize * 2, self.frame.size.height)];
        } else if (_titleRowLab) {
            _titleRowLab.textAlignment = NSTextAlignmentCenter;
            [_titleRowLab setFrame:CGRectMake(_moveTitleSize, 0, self.frame.size.width - _moveTitleSize * 2, self.frame.size.height)];
        }
        
    } else if (_moveTitleType == 1) {
        if (_titleRowField) {
            _titleRowField.textAlignment = NSTextAlignmentRight;
            [_titleRowField setFrame:CGRectMake(0, 0, self.frame.size.width - _moveTitleSize, self.frame.size.height)];
        } else if (_titleRowLab) {
            _titleRowLab.textAlignment = NSTextAlignmentRight;
            [_titleRowLab setFrame:CGRectMake(0, 0, self.frame.size.width - _moveTitleSize, self.frame.size.height)];
        }
        
    } else if (_moveTitleType == -1) {
        if (_titleRowField) {
            _titleRowField.textAlignment = NSTextAlignmentLeft;
            [_titleRowField setFrame:CGRectMake(_moveTitleSize, 0, self.frame.size.width - _moveTitleSize, self.frame.size.height)];
        } else if (_titleRowLab) {
            _titleRowLab.textAlignment = NSTextAlignmentLeft;
            [_titleRowLab setFrame:CGRectMake(_moveTitleSize, 0, self.frame.size.width - _moveTitleSize, self.frame.size.height)];
        }
        
    }
    
    if (imgLogo) {
        [imgLogo setFrame:CGRectMake(self.frame.size.width - imgLogo.image.size.width, (self.frame.size.height - imgLogo.image.size.height) / 2, imgLogo.image.size.width, imgLogo.image.size.height)];
    }
    
    if (self.separatorStyle == DQKRowViewCellSeparatorStyleSingleLine) {
        [self setLine];
    }
}

//////////////////////// 事件
- (void)rowToDo{
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(touchRow:)]) {
        [_cellDelegate touchRow:self];
    }
}

- (void)textFieldChange:(UITextField *)textField{
    if ([_cellDelegate respondsToSelector:@selector(changerToRowBack:)]) {
        [_cellDelegate changerToRowBack:self];
    }
}

@end
