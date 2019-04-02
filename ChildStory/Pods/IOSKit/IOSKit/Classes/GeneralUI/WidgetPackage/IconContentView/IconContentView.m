//
//  IconContentView.m
//  kp
//
//  Created by gzkp on 2017/5/18.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "IconContentView.h"
#import "GeneralConfig.h"
#import "UIView+SDAutoLayout.h"

@interface IconContentView()




@end


@implementation IconContentView

+ (IconContentView*)createViewWithImage:(UIImage*)image content:(NSString *)content contentColor:(UIColor*)contentColor contentFont:(UIFont *)contentFont
{
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.text = content;
    contentLabel.font = contentFont;
    contentLabel.textColor = contentColor;
    [contentLabel sizeToFit];
    
    UILabel *postfixLabel = [[UILabel alloc]init];
    postfixLabel.font = FontSize(16);
    postfixLabel.textColor = kUIColorFromRGB(0x888888);
    
    UIImageView *iconImV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    iconImV.image = image;
    
    
    
    IconContentView *itemView = [[IconContentView alloc]initWithFrame:CGRectMake(0, 0, iconImV.width + contentLabel.width + 1, 25)];
    //    itemView.backgroundColor = BG_COLOR;
    [itemView addSubview:contentLabel];
    [itemView addSubview:postfixLabel];
    [itemView addSubview:iconImV];
    itemView.contentLabel = contentLabel;
    itemView.postfixLabel = postfixLabel;
    
    iconImV.sd_layout
    .centerYEqualToView(itemView)
    .leftEqualToView(itemView)
    .widthIs(22)
    .heightIs(22);
    
    contentLabel.sd_layout
    .centerYEqualToView(itemView)
    .leftSpaceToView(iconImV, 5)
    .widthIs(contentLabel.width)
    .heightIs(contentLabel.height);
    
    postfixLabel.sd_layout
    .centerYEqualToView(itemView)
    .leftSpaceToView(iconImV, contentLabel.width + 5)
    .widthIs(contentLabel.width)
    .heightIs(contentLabel.height);
    
    return itemView;
    
}


+ (IconContentView*)createViewWithImage:(UIImage*)image content:(NSString *)content contentColor:(UIColor*)contentColor
{
    return [self createViewWithImage:image content:content contentColor:contentColor contentFont:FontSize(18)];
}


- (void)setContent:(NSString*)content postfix:(NSString*)postfix
{
    self.contentLabel.text = content;
    [self.contentLabel sizeToFit];
    self.postfixLabel.text = postfix;
    [self.postfixLabel sizeToFit];
    
    
    _contentLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 24)
    .widthIs(_contentLabel.width)
    .heightIs(_contentLabel.height);
    
    _postfixLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(_contentLabel, 5)
    .widthIs(_postfixLabel.width)
    .heightIs(_postfixLabel.height);
    
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
