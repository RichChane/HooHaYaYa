//
//  DQKMainViewCell.m
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "DQKMainViewCell.h"

#import <IOSKit/GeneralConfig.h>

@interface DQKMainViewCell ()<UITextFieldDelegate>

@property (strong, nonatomic) UIView *leftLine;
@property (strong, nonatomic) UIView *rightLine;
@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;



@end

@implementation DQKMainViewCell

- (instancetype)initWithStyle:(DQKMainViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        _rowNumber = 1;
        _sectionNumber = 1;
        [self addLine];
        _style = style;
        switch (style) {
            case DQKMainViewCellStyleDefault:
            {
                _titleTextField = [[KPTextField alloc] init];
                _titleTextField.delegate = self;
                _titleTextField.textAlignment = NSTextAlignmentCenter;
                _titleTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                _titleTextField.font = [UIFont systemFontOfSize:15];
                [_titleTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
                [self addSubview:_titleTextField];
            }
                break;
            case DQKMainViewCellStyleCustom:
            {
                
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    _titleTextField.tag = tag;
}

- (void)setTitle:(NSString *)t {
    self.titleTextField.text = t;
}
- (NSString *)title{
    return self.titleTextField.text;
}

- (void)buildPlaceholder:(NSString *)p{
    self.titleTextField.placeholder = p;
}

- (void)setSelectedColor:(UIColor *)col
{
    [self.titleTextField setTextColor:col];
    self.layer.borderColor = col.CGColor;//kUIColorFromRGB(0x4077CE).CGColor;
    self.layer.borderWidth = 1;
}

- (void)setNormalColor:(UIColor *)col
{
    [self.titleTextField setTextColor:col];
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 1;
}

- (void)setSeparatorStyle:(DQKMainViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    if (separatorStyle == DQKMainViewCellSeparatorStyleNone) {
        [self removeLine];
    }
}

- (void)setIsTextEditable:(BOOL)isTextEditable
{
    _isTextEditable = isTextEditable;
    _titleTextField.userInteractionEnabled = isTextEditable;
}

- (void)addLine {
    UIColor *lineGrayColor = kUIColorFromRGB(0xD9D9D9);
    _leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    _leftLine.backgroundColor = lineGrayColor;
    [self addSubview:_leftLine];
    _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    _rightLine.backgroundColor = lineGrayColor;
    [self addSubview:_rightLine];
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    _topLine.backgroundColor = lineGrayColor;
    [self addSubview:_topLine];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
    _bottomLine.backgroundColor = lineGrayColor;
    [self addSubview:_bottomLine];
}

- (void)removeLine {
    [self.leftLine removeFromSuperview];
    [self.rightLine removeFromSuperview];
    [self.topLine removeFromSuperview];
    [self.bottomLine removeFromSuperview];
}

- (void)setLine {
    [self.leftLine setFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    [self.rightLine setFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    [self.topLine setFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    [self.bottomLine setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.style == DQKMainViewCellStyleDefault) {
        
        if (self.isSingle) {
            [self.titleTextField setFrame:CGRectMake(15, 0, self.frame.size.width - 15, self.frame.size.height)];
            self.titleTextField.textAlignment = NSTextAlignmentLeft;
        }else{
            [self.titleTextField setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        }
        
    }
    if (self.separatorStyle == DQKMainViewCellSeparatorStyleSingleLine) {
        [self setLine];
    }
}

/////////////////////
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([_cellDelegate respondsToSelector:@selector(willBeginDo:)]) {
        return [_cellDelegate willBeginDo:self];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([_cellDelegate respondsToSelector:@selector(changerBeginDo:)]) {
        [_cellDelegate changerBeginDo:self];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(mainCell:textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [_cellDelegate mainCell:self textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (void)textFieldChange:(UITextField *)textField{
    if (self.callBack) {
        self.callBack(textField.text);
    }
    if ([_cellDelegate respondsToSelector:@selector(changerToBack:)]) {
        [_cellDelegate changerToBack:self];
    }
}

@end
