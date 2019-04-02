//
//  InputTextView.h
//  kpkd
//
//  Created by gzkp on 2018/5/29.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputTextViewDelegate;

@interface InputTextView : UIView

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,weak) id<InputTextViewDelegate> inputDelegate;

- (id)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHodler text:(NSString *)text;

@end


@protocol InputTextViewDelegate <NSObject>

- (void)textViewDidChange:(UITextView *)textView;


@end

