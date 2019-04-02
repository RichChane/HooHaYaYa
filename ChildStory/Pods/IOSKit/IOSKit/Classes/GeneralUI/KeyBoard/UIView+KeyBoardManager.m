//
//  UIView+KeyBoardManager.m
//  kp
//
//  Created by gzkp on 2017/6/12.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "UIView+KeyBoardManager.h"
#import "YYKeyboardManager.h"
#import "GeneralConfig.h"

static NSArray *_textFieldCollection;
static CGRect _originFrame;
static ScrollType _scrollType;
static CGFloat _needRecordItemHeight;
static CGFloat _additionalHeight;

@implementation UIView (KeyBoardManager)

- (void)addKeyBoardNotice
{
    //键盘高度的变换
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[YYKeyboardManager defaultManager] addObserver:self];
}

- (void)removeKeyBoardObserver
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[YYKeyboardManager defaultManager] removeObserver:self];
}

#pragma mark - @protocol YYKeyboardObserver

- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition {
    [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption animations:^{
        UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
        CGRect kbFrame = [[YYKeyboardManager defaultManager] convertRect:transition.toFrame toView:keyWindow];
        //获取当前第一响应者
        UITextField *textField = [keyWindow performSelector:@selector(firstResponder)];
        CGRect textFieldFrame;
        if (_scrollType == ScrollViewNormal) {
            textFieldFrame = [textField convertRect:textField.frame toView:keyWindow];//
        }else if (_scrollType == ScrollViewTable){
            textFieldFrame = [textField convertRect:textField.frame toView:self];//
        }else{
            
        }

        if (CGRectGetMaxY(textFieldFrame) > kbFrame.origin.y) {
            CGRect textframe = self.frame;
            textframe.origin.y = kbFrame.origin.y - CGRectGetMaxY(textFieldFrame);
//            if (CGRectGetMaxY(textframe) < kbFrame.origin.y) {
////                textframe.origin.y = keyWindow.height - (self.height + kbFrame.size.height);
//                textframe.origin.y = textframe.origin.y + kbFrame.origin.y - CGRectGetMaxY(textframe);
//            }
            self.frame = textframe;
            
        }else if (kbFrame.origin.y == SCREEN_HEIGHT){//收键盘
            self.frame = _originFrame;
            
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setScrollType:(ScrollType)scrollType
{
    _scrollType = scrollType;
}

- (void)setOriginFrame:(CGRect)originFrame
{
    _needRecordItemHeight = 0;
    _originFrame = originFrame;
}

- (void)setScrollType:(ScrollType)scrollType originFrame:(CGRect)originFrame
{
    _scrollType = scrollType;
    _originFrame = originFrame;
}

- (void)setTextFieldCollection:(NSArray *)textFieldCollection
{
    _needRecordItemHeight = 0;
    _textFieldCollection = textFieldCollection;
}

- (void)setAdditionalHeight:(CGFloat)additionalHeight
{
    _additionalHeight = additionalHeight;
}

#pragma mark - Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    
    if (_needRecordItemHeight != 0) {//键盘若弹起后没收到通知收回，则不处理
        NSLog(@"键未收起：%f",_needRecordItemHeight);
        return;
    }
    
    //获取当前第一响应者
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UITextField *textField = [keyWindow performSelector:@selector(firstResponder)];
    
//    for (UITextField *textField in _textFieldCollection) {
        NSLog(@"键盘-------:%@",textField.text);
        
        if (textField.isFirstResponder) {
            
            CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
            CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
            
            NSString *keyBoardName = [[UITextInputMode currentInputMode] primaryLanguage];
            NSArray *keyModed = [UITextInputMode activeInputModes];
            
            // 第三方键盘回调三次问题，监听仅执行最后一次
            if(begin.size.height>0 && (begin.origin.y-end.origin.y>0))
            {
                
                
                UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
                //    CGRect rect=[_recordLine convertRect: _recordLine.bounds toView:window];//原来的
                CGRect rect=[textField convertRect: textField.frame toView:window];//
                _needRecordItemHeight = window.frame.size.height - rect.origin.y - rect.size.height;
                NSInteger type = 1;
                [self autoMovekeyBoardWithType:type andNotification:notification];
                
            }
        }
//    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self autoMovekeyBoardWithType:0 andNotification:notification];
}

-(void)autoMovekeyBoardWithType:(NSInteger)type andNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    float keyBoardHeight = [aValue CGRectValue].size.height;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:duration.doubleValue delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        if (type == 1)
        {//keyboard show
            CGFloat changeFrameValue = _needRecordItemHeight - keyBoardHeight + _additionalHeight;
            changeFrameValue = changeFrameValue < 0? changeFrameValue:0;
            changeFrameValue = changeFrameValue - _additionalHeight;
            self.frame = CGRectMake(0, changeFrameValue, self.frame.size.width, self.frame.size.height);
            
        }
        else if (type == 0)
        {//hide
            self.frame = _originFrame;
            _needRecordItemHeight = 0;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}



@end
