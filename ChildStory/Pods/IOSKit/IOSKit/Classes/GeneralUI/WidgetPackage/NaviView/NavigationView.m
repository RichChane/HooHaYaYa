//
//  NavigationView.m
//  kpkd
//
//  Created by gzkp on 2017/9/8.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "NavigationView.h"
#import "GeneralConfig.h"


@implementation NavigationView
{
    CGFloat _itemHeight;
    CGFloat NaviViewHeight;
}

- (instancetype)init
{
    if (SizeHeight_IphoneX == SCREEN_HEIGHT) {
        NaviViewHeight = 88;
        _itemHeight = NaviViewHeight - 40;
    }else{
        NaviViewHeight = 64;
        _itemHeight = NaviViewHeight - GC.topBarNowHeight;
    }
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NaviViewHeight)];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, GC.topBarNowHeight, self.frame.size.width - 200, _itemHeight)];
        _titleLabel = titleLabel;
        titleLabel.textColor = kUIColorFromRGB(0x000000);
        titleLabel.font = FontSize(18);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(ASIZE(10), GC.topBarNowHeight, 39, _itemHeight)];
        _leftBtn = backBtn;
        [backBtn setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
        [self addSubview:backBtn];
        backBtn.tintColor = GC.MC;
        
        CGFloat rightBtnWidth = 50;
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - rightBtnWidth - 15, GC.topBarNowHeight, rightBtnWidth, _itemHeight)];
        _rightBtn = rightBtn;
        [rightBtn setTitleColor:GC.MC forState:UIControlStateNormal];
        [self addSubview:rightBtn];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setRightBtnTitle:(NSString *)rightBtnTitle
{
    [self addSubview:_rightBtn];
    [_rightBtn setTitle:rightBtnTitle forState:UIControlStateNormal];
}

- (void)setRightBtn:(UIButton *)rightBtn
{
    _rightBtn = rightBtn;
    [self addSubview:rightBtn];
    _rightBtn.frame = CGRectMake(self.frame.size.width - rightBtn.frame.size.width - 15, (_itemHeight - rightBtn.frame.size.height)/2 + GC.topBarNowHeight, rightBtn.frame.size.width, rightBtn.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
