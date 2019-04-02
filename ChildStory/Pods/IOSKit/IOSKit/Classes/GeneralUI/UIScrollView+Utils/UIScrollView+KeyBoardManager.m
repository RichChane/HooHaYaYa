//
//  UIScrollView+KeyBoardManager.m
//  PreciousMetal
//
//  Created by DemoLi on 16/9/19.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "UIScrollView+KeyBoardManager.h"


#define BASE_HEIGHT 216
#define BASE_VIEW_HEGIHT 568

static CGFloat needRecordItemHeight;
static BOOL _isKeyBoardShow;

@implementation UIScrollView (KeyBoardManager)

- (void)addKeyBoardNotice
{
    [self performSelector:@selector(delayAddKeyBoardNotice) withObject:nil afterDelay:0];
    
}

- (void)delayAddKeyBoardNotice
{
    //键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)removeKeyBoardObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0))
    {
        if (_isKeyBoardShow == NO) {//键盘会多次吊起 防止重复调用
            _isKeyBoardShow = YES;
            
            [self recordItemMaxYForKeyBoard];
            NSInteger type = 1;
            [self autoMovekeyBoardWithType:type andNotification:notification];
        }

    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (_isKeyBoardShow == YES) {//键盘会多次吊起 防止重复调用
        _isKeyBoardShow = NO;
        NSInteger type = 0;
        [self autoMovekeyBoardWithType:type andNotification:notification];

    }
    
}

-(void)autoMovekeyBoardWithType:(NSInteger)type andNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    float keyBoardHeight = [aValue CGRectValue].size.height;
    
    UIScrollView *scrollView = self;
    CGPoint contentOffset = scrollView.contentOffset;
    CGSize contentSize = scrollView.contentSize;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:duration.doubleValue delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        if (type == 1)
        {//keyboard show
            scrollView.contentOffset = CGPointMake(contentOffset.x, contentOffset.y + (keyBoardHeight - needRecordItemHeight));
            scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + keyBoardHeight);
            
        }
        else if (type == 0)
        {//hide
            //scrollView.contentOffset = CGPointMake(contentOffset.x, contentOffset.y - (keyBoardHeight - needRecordItemHeight));
            scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height - keyBoardHeight);
            needRecordItemHeight = 0;
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)recordItemMaxYForKeyBoard{}//计算控件距离屏幕底部的距离，来计算view需要弹起的高度

- (void)setNeedRecordItemHeight:(CGFloat)itemHeight
{
    needRecordItemHeight = itemHeight;
    
}






@end
