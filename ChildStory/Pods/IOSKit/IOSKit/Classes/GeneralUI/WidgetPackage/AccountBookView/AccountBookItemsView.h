//
//  AccountBookItemsView.h
//  kp
//
//  Created by gzkp on 2017/5/26.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountBookItemsView : UIView

@property (nonatomic,strong) UIImageView *leftIconImV;
@property (nonatomic,strong) UILabel *accountTitleLabel;
@property (nonatomic,strong) UILabel *accountAmountLabel;
@property (nonatomic,strong) UILabel *accountCodeLabel;
@property (nonatomic,strong) UIButton *accountCodeBtn;
@property (nonatomic,strong) UILabel *orderTypeLabel;
@property (nonatomic,strong) UILabel *accountNameLabel;

- (void)setOrderTypeWithType:(NSString *)text;


@end

