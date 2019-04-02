//
//  LittleImageBigControl.m
//  YBar
//
//  Created by Rich on 16/5/28.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "LittleImageBigControl.h"
#import "SDAutoLayout.h"

@implementation LittleImageBigControl

+ (LittleImageBigControl*)createTopRightControlWithSize:(CGSize)size littleImage:(UIImage *)littleImage
{
    CGRect frame = CGRectMake(0, 0, 0, 0);
    frame.size = size;
    LittleImageBigControl *bigControl = [[LittleImageBigControl alloc]initWithFrame:frame];
    UIImageView *littleImV = [[UIImageView alloc]initWithImage:littleImage];
    [bigControl addSubview:littleImV];
    littleImV.sd_layout
    .rightEqualToView(bigControl)
    .topEqualToView(bigControl)
    .widthIs(littleImage.size.width)
    .heightIs(littleImage.size.height);
    
    return bigControl;
    
}

+ (LittleImageBigControl*)createControlWithSize:(CGSize)size imageName:(NSString *)imageName
{
    UIImage *littleImage = [UIImage imageNamed:imageName];
    CGRect frame = CGRectMake(0, 0, 0, 0);
    frame.size = size;
    LittleImageBigControl *bigControl = [[LittleImageBigControl alloc]initWithFrame:frame];
    UIImageView *littleImV = [[UIImageView alloc]initWithImage:littleImage];
    littleImV.frame = CGRectMake(0, 0, littleImage.size.width, littleImage.size.height);
    littleImV.center = bigControl.center;
    [bigControl addSubview:littleImV];
    return bigControl;
    
}

+ (LittleImageBigControl*)createControlWithBigFrame:(CGRect)bigFrame littleSize:(CGSize)littleSize imageName:(NSString *)imageName
{

    LittleImageBigControl *bigControl = [[LittleImageBigControl alloc]initWithFrame:bigFrame];
    UIImageView *littleImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    littleImV.frame = CGRectMake(0, 0, littleSize.width, littleSize.height);
    littleImV.center = CGPointMake(bigControl.width/2, bigControl.height/2 - 10);
    [bigControl addSubview:littleImV];
    return bigControl;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
