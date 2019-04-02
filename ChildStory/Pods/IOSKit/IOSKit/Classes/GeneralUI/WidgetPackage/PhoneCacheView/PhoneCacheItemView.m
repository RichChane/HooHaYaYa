//
//  PhoneCacheItemView.m
//  kpkd
//
//  Created by gzkp on 2017/7/18.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "PhoneCacheItemView.h"
#import "UIImageView+userHeaderImage.h"
#import "GeneralConfig.h"
#import "UIView+SDAutoLayout.h"

@interface PhoneCacheItemView()


@property (nonatomic,strong) UIButton *tapControl;
@property (nonatomic,strong) UIImageView *userHeaderImV;
@property (nonatomic,strong) UILabel *userPhoneLabel;
@property (nonatomic,strong) UILabel *userNameLabel;


@end


@implementation PhoneCacheItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

        UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
        if (bgView.frame.size.height > 55) {
            CGRect frame = bgView.frame;
            frame.size.height = 55;
            bgView.frame = frame;
        }
        [self addSubview:bgView];
        bgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        //名字
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = FontSize(15);
        _userNameLabel.textColor = [UIColor blackColor];
        [bgView addSubview:_userNameLabel];
        _userNameLabel.sd_layout
        .leftSpaceToView(bgView, 0)
        .topSpaceToView(bgView, 5)
        .widthIs(200)
        .heightIs(16);
        
        //电话号码
        _userPhoneLabel = [[UILabel alloc]init];
        _userPhoneLabel.font = FontSize(15);
        _userPhoneLabel.textColor = kUIColorFromRGB(0xCCCCCC);
        [bgView addSubview:_userPhoneLabel];
        _userPhoneLabel.sd_layout
        .leftSpaceToView(bgView, 0)
        .topSpaceToView(_userNameLabel, 5)
        .widthIs(200)
        .heightIs(16);

        UIImage *deleteImg = [UIImage imageNamed:@"common_delete"];
        _deleteBtn = [[UIButton alloc]init];
        [_deleteBtn setImage:deleteImg forState:UIControlStateNormal];
        [bgView addSubview:_deleteBtn];
        _deleteBtn.sd_layout
        .rightSpaceToView(bgView, 15)
        .centerYEqualToView(bgView)
        .widthIs( deleteImg.size.width)
        .heightIs( deleteImg.size.height);
        
        _userHeaderImV = [[UIImageView alloc]init];
        [bgView addSubview:_userHeaderImV];
        _userHeaderImV.sd_layout
        .centerYEqualToView(bgView)
        .rightSpaceToView(_deleteBtn, 5)
        .widthIs(40)
        .heightIs(40);
        _userHeaderImV.layer.cornerRadius = 20;
        _userHeaderImV.layer.masksToBounds = YES;
        
        
        UIButton *itemControl = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 50, self.frame.size.height)];
        [self addSubview:itemControl];
        _tapControl = itemControl;
    }
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    _deleteBtn.tag = tag;
    _tapControl.tag = tag;
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    _userNameLabel.text = userName;
    
}

- (void)setUserPhone:(NSString *)userPhone
{
    _userPhone = userPhone;
    _userPhoneLabel.text = userPhone;
    
}

- (void)setUserHeaderUrl:(NSString *)userHeaderUrl
{
    [_userHeaderImV setImageURL:userHeaderUrl userName:_userName];
}

- (void)addDelTarget:(id)target action:(SEL)action
{
    [_deleteBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addChooseTarget:(id)target action:(SEL)action
{
    [_tapControl addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
