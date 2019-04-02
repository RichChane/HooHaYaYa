//
//  NavigationView.h
//  kpkd
//
//  Created by gzkp on 2017/9/8.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationView : UIView

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

- (void)setRightBtnTitle:(NSString *)rightBtnTitle;

@end
