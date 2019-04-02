//
//  SwitchLine.h
//  kp
//
//  Created by gzkp on 2017/10/26.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchOffOn)(bool isOn);

@interface SwitchLine : UIView

@property (nonatomic,assign) BOOL isOn;
@property (nonatomic,copy) SwitchOffOn switchAction;
@property (nonatomic,assign) UISwitch *switchBtn;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title offOn:(BOOL)offOn;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title SubTitle:(NSString *)subTitle offOn:(BOOL)offOn;

@end
