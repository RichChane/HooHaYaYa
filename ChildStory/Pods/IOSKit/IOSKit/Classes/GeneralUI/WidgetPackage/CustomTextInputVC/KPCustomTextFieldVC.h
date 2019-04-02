//
//  KPCustomTextFieldVC.h
//  kp
//
//  Created by gzkp on 2018/8/8.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "GeneralViewController.h"

typedef void(^CustomTextInputBlock)(NSString * text);

@interface KPCustomTextFieldVC : GeneralViewController

@property (nonatomic,weak) id textFieldDelegate;
@property (nonatomic, copy) CustomTextInputBlock textInputBlock;
@property (nonatomic,assign) UIKeyboardType keyboardType;

- (instancetype)initWithTitle:(NSString *)title AndPlaceholder:(NSString *)placeholder AndText:(NSString *)text AndTextMaxLength:(NSInteger)textMaxLength;

@end
