//
//  ContentChooseView.m
//  kp
//
//  Created by gzkp on 2017/5/16.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "ContentChooseView.h"
#import "GeneralConfig.h"
#import "UIView+SDAutoLayout.h"

@interface ContentChooseView()

@property (nonatomic,strong) UILabel *contentLable;



@end


@implementation ContentChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //content
        _contentLable = [[UILabel alloc]init];
        _contentLable.font = FontSize(16);
        _contentLable.textColor = kUIColorFromRGB(0x3D4245);
        [self addSubview:_contentLable];
     
        _contentLable.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .heightIs(self.height)
        .widthIs(self.width*0.75);
        
        //arrow
        UIImageView *arrowImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_right"]];
        [self addSubview:arrowImV];
        
        arrowImV.sd_layout
        .rightSpaceToView(self, 30)
        .centerYEqualToView(self)
        .widthIs(arrowImV.width)
        .heightIs(arrowImV.height);
        
        //line
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = RGB(221,221,221);
        [self addSubview:line];
        
        line.sd_layout
        .leftSpaceToView(self, 0)
        .bottomSpaceToView(self, OnePX)
        .widthIs(self.width)
        .heightIs(OnePX);
        
    }
    return self;
}


#pragma mark - set&get
- (void)setContent:(NSString*)content
{
    _contentLable.text = content;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
