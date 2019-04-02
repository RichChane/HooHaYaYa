//
//  CustomTextInputVC.h
//  kpkd
//
//  Created by lkr on 2018/8/6.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "GeneralViewController.h"

typedef void(^CustomTextInputBlock)(NSString * text);

/// 自定义输入框VC  可用于备注编辑输入
@interface CustomTextInputVC : GeneralViewController

@property (nonatomic, copy)CustomTextInputBlock textInputBlock;

- (instancetype)initWithTitle:(NSString *)title AndPlaceholder:(NSString *)placeholder AndText:(NSString *)text AndTextMaxLength:(NSInteger)textMaxLength;
- (instancetype)initWithTitle:(NSString *)title AndPlaceholder:(NSString *)placeholder AndText:(NSString *)text AndTextMaxLength:(NSInteger)textMaxLength IsHaveFinish:(BOOL)isHaveFinishBtn;

@end
