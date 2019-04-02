//
//  InputTextView.m
//  kpkd
//
//  Created by gzkp on 2018/5/29.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "InputTextView.h"
#import "GeneralConfig.h"

@interface InputTextView ()<UITextViewDelegate>


@property (nonatomic,strong) UILabel *placeHolderLabel;

@end


@implementation InputTextView

- (id)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHodler text:(NSString *)text
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UILabel *placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 + 5, 5, SCREEN_WIDTH - 15*2, 30)];
        _placeHolderLabel = placeHolderLabel;
        placeHolderLabel.text = placeHodler;
        placeHolderLabel.font = FontSize(15);
        placeHolderLabel.textColor = kUIColorFromRGB(0xD8D8D8);
        [self addSubview:placeHolderLabel];
        
        UITextView *feedBackTextField = [[UITextView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH - 15*2, 150)];
        _textView = feedBackTextField;
        feedBackTextField.font = FontSize(15);
        feedBackTextField.delegate = self;
        //feedBackTextField.textColor = kUIColorFromRGB(0xE64340);
        feedBackTextField.backgroundColor = [UIColor clearColor];
        [self addSubview:feedBackTextField];
        feedBackTextField.tintColor = kUIColorFromRGB(0xFEE2B4);
        feedBackTextField.text = text;
        
        if (text && text.length) {
            placeHolderLabel.hidden = YES;
        }
        
    }
    
    return self;
    
}

- (NSString *)text
{
    return _textView.text;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        _placeHolderLabel.hidden = NO;
    }else
    {
        _placeHolderLabel.hidden = YES;
    }
    if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.inputDelegate textViewDidChange:textView];
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
