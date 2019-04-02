//
//  EmptyDataView.m
//  kp
//
//  Created by gzkp on 2018/1/19.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "EmptyDataView.h"
#import "GeneralConfig.h"
#import <KPFoundation/KPFoundation.h>

@implementation EmptyDataView

+ (id)createEmptyDataView
{
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.text = ML(@"暂时没有数据");
    textLabel.textColor = kUIColorFromRGB(0xA4A5AA);
    textLabel.font = FontSize(14);
    [textLabel sizeToFit];
    
    
    
    CGFloat emptyViewWidth = 84;
    if (textLabel.frame.size.width < 84) {
        emptyViewWidth = 84;
    }
    EmptyDataView *emptyView = [[EmptyDataView alloc]initWithFrame:CGRectMake(0, 0, emptyViewWidth, ASIZE(91))];
    
    UIImageView *imv = [[UIImageView alloc]initWithImage:ImageName(@"nodata")];
    [emptyView addSubview:imv];
    
    imv.frame = CGRectMake((emptyViewWidth-imv.frame.size.width)/2, 0, imv.frame.size.width, imv.frame.size.height);
    CGRect emptyViewFrame = emptyViewFrame;
    emptyViewFrame.size.height = imv.frame.size.height+textLabel.frame.size.height+10;
    emptyView.frame = emptyViewFrame;
    textLabel.frame = CGRectMake((emptyViewWidth-textLabel.frame.size.width)/2, emptyView.frame.size.height-textLabel.frame.size.height, textLabel.frame.size.width, textLabel.frame.size.height);
    
    
    [emptyView addSubview:textLabel];                                                                                             
    return emptyView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
