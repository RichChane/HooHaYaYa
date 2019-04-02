//
//  AccountBookItemsView.m
//  kp
//
//  Created by gzkp on 2017/5/26.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "AccountBookItemsView.h"
#import "NSString+Size.h"
#import "GeneralConfig.h"
#import "UIView+SDAutoLayout.h"
#import <KPFoundation/KPFoundation.h>

@interface AccountBookItemsView()


@end



@implementation AccountBookItemsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createLeftImV];
        [self createAccountTitleLabel];
        [self createAccountAmountLabel];
        [self createAccountCodeLabel];
        [self createOrderTypeLabel];
        [self createAccountNameLabel];
        
    }
    return self;
}

- (void)createLeftImV
{
    _leftIconImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"receipt_money1"]];
    [self addSubview:_leftIconImV];
    _leftIconImV.sd_layout
    .leftSpaceToView(self, 15)
    .centerYEqualToView(self)
    .widthIs(_leftIconImV.frame.size.width)
    .heightIs(_leftIconImV.frame.size.height);
    
    
}

- (void)createAccountTitleLabel
{
    _accountTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    _accountTitleLabel.textColor = kUIColorFromRGB(0x3D4245);
    _accountTitleLabel.font = FontSize(14);
    [self addSubview:_accountTitleLabel];
    _accountTitleLabel.sd_layout
    .leftSpaceToView(_leftIconImV, 5)
    .topSpaceToView(self, 10)
    .widthIs(_accountTitleLabel.width)
    .heightIs(_accountTitleLabel.height);
    
    
}

- (void)createAccountAmountLabel
{
    _accountAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 28)];
    _accountAmountLabel.textColor = kUIColorFromRGB(0x3D4245);
    _accountAmountLabel.font = FontSize(20);
    _accountAmountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_accountAmountLabel];
    _accountAmountLabel.sd_layout
    .rightSpaceToView(self, 15)
    .centerYEqualToView(_accountTitleLabel)
    .widthIs(_accountAmountLabel.width)
    .heightIs(_accountAmountLabel.height);
    
    
}

- (void)createAccountCodeLabel
{
    _accountCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    _accountCodeLabel.textColor = kUIColorFromRGB(0xADADAD);
    _accountCodeLabel.font = FontSize(13);
    [self addSubview:_accountCodeLabel];
    _accountCodeLabel.sd_layout
    .leftSpaceToView(_leftIconImV, 5)
    .topSpaceToView(_accountTitleLabel, 0)
    .widthIs(_accountCodeLabel.width)
    .heightIs(_accountCodeLabel.height);
    
    _accountCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    [self addSubview:_accountCodeBtn];
    _accountCodeBtn.sd_layout
    .leftSpaceToView(_leftIconImV, 5)
    .topSpaceToView(_accountTitleLabel, 0)
    .widthIs(_accountCodeLabel.width)
    .heightIs(_accountCodeLabel.height);
    
    _orderTypeLabel = [[UILabel alloc]init];
    _orderTypeLabel.layer.borderColor = kUIColorFromRGB(0xFFA358).CGColor;
    _orderTypeLabel.layer.borderWidth = 1;
    _orderTypeLabel.layer.cornerRadius = 4;
    _orderTypeLabel.font = FontSize(13);
    _orderTypeLabel.textColor = kUIColorFromRGB(0xFC8F06);
    _orderTypeLabel.backgroundColor = kUIColorFromRGB(0xFEF2E6);
    _orderTypeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_orderTypeLabel];
    _orderTypeLabel.sd_layout
    .leftSpaceToView(_accountCodeLabel, 5)
    .centerYEqualToView(_accountCodeLabel)
    .widthIs(70)
    .heightIs(17);
    
    _orderTypeLabel.text = ML(@"单据作废");
}

- (void)createOrderTypeLabel
{
 
}

- (void)createAccountNameLabel
{
    _accountNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    _accountNameLabel.textColor = kUIColorFromRGB(0xADADAD);
    _accountNameLabel.font = FontSize(13);
    _accountNameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_accountNameLabel];
    _accountNameLabel.sd_layout
    .rightSpaceToView(self, 15)
    .centerYEqualToView(_accountCodeLabel)
    .leftSpaceToView(_accountCodeLabel, 10)
    .heightIs(_accountNameLabel.height);
    
    
}

- (void)setOrderTypeWithType:(NSString *)text;
{
    _orderTypeLabel.text = text;
    CGSize size = [_accountCodeLabel.text sizeWithFont:_accountCodeLabel.font maxSize:CGSizeMake(999, _accountCodeLabel.height)];
    _accountCodeLabel.sd_layout
    .leftSpaceToView(_leftIconImV, 5)
    .topSpaceToView(_accountTitleLabel, 0)
    .widthIs(size.width+10)
    .heightIs(_accountCodeLabel.height);
    
    _orderTypeLabel.sd_layout
    .leftSpaceToView(_accountCodeLabel, 0)
    .centerYEqualToView(_accountCodeLabel)
    .widthIs(70)
    .heightIs(17);
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

