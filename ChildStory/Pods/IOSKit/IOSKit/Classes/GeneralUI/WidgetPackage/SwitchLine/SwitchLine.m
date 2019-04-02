//
//  SwitchLine.m
//  kp
//
//  Created by gzkp on 2017/10/26.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "SwitchLine.h"
#import "UIView+changeColor.h"
#import "UIView+SDAutoLayout.h"
#import "GeneralConfig.h"

@interface SwitchLine()




@end



@implementation SwitchLine

- (id)initWithFrame:(CGRect)frame title:(NSString *)title offOn:(BOOL)offOn
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UISwitch *switchBtn = [[UISwitch alloc]init];
        _switchBtn = switchBtn;
        [switchBtn addTarget:self action:@selector(moreSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [switchBtn setDefaultChangeColor];
        [self addSubview:switchBtn];
        switchBtn.sd_layout
        .rightSpaceToView(self, 0)
        .centerYEqualToView(self)
        .widthIs(switchBtn.width)
        .heightIs(switchBtn.height);
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ASIZE(200), self.height)];
        rightLabel.font = FontSize(17);
        rightLabel.textColor = [UIColor blackColor];
        rightLabel.text = title;
        [self addSubview:rightLabel];
        rightLabel.sd_layout
        .leftSpaceToView(0, 0)
        .centerYEqualToView(self);
        
        
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title SubTitle:(NSString *)subTitle offOn:(BOOL)offOn {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UISwitch *switchBtn = [[UISwitch alloc]init];
        _switchBtn = switchBtn;
        [switchBtn addTarget:self action:@selector(moreSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [switchBtn setDefaultChangeColor];
        [self addSubview:switchBtn];
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ASIZE(200), self.height)];
        titleLabel.font = FontSize(17);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        
        if (subTitle) {
            
            switchBtn.sd_layout
            .rightSpaceToView(self, 0)
            .topSpaceToView(self, ASIZE(15))
            .widthIs(switchBtn.width)
            .heightIs(switchBtn.height);
            
            titleLabel.sd_layout
            .leftSpaceToView(0, 0)
            .topSpaceToView(self, ASIZE(18))
            .heightIs(ASIZE(24));
            
            UILabel *subTitleLabel = [[UILabel alloc]init];
            subTitleLabel.font = FontSize(15);
            subTitleLabel.textColor = kUIColorFromRGB(0x7F7F7F);
            subTitleLabel.text = subTitle;
            [self addSubview:subTitleLabel];
            subTitleLabel.sd_layout
            .leftSpaceToView(0, 0)
            .rightSpaceToView(self, 0)
            .bottomSpaceToView(self, ASIZE(15))
            .heightIs(ASIZE(21));
            
        }else {
            
            switchBtn.sd_layout
            .rightSpaceToView(self, 0)
            .centerYEqualToView(self)
            .widthIs(switchBtn.width)
            .heightIs(switchBtn.height);
            
            titleLabel.sd_layout
            .leftSpaceToView(0, 0)
            .centerYEqualToView(self);
        }
    }
    return self;
}

- (void)moreSwitchAction:(UISwitch *)sender
{
    self.isOn = sender.isOn;
    if (self.switchAction) {
        self.switchAction(self.isOn);
    }
}

- (void)setIsOn:(BOOL)isOn
{
//    _isOn = isOn;
    [_switchBtn setOn:isOn];
    
}

- (BOOL)isOn
{
    return _switchBtn.isOn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
