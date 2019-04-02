//
//  AssociateTabBar.m
//  CCBShop
//
//  Created by zyy_pro on 14-6-23.
//  Copyright (c) 2014年 CCB. All rights reserved.
//

#import <IOSKit/AssociateTabBar.h>

@implementation AssociateTabBar

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray Delegate:(id<TabBarDelegate>)theDelega
{
    self = [super initWithFrame:frame];
    if (self) {
        delegate = theDelega;
        
        self.backgroundColor = [UIColor colorWithRed:0xd2/255.0 green:0x2d/255.0 blue:0x39/255.0 alpha:1.0];
		
		CGFloat originY = 50;
		for (int i = 0; i < [imageArray count]; i++)
		{
            UIImage *sideImage = [UIImage imageNamed:[(NSDictionary *)[imageArray objectAtIndex:i] objectForKey:TabBarSide]];
            if (!(sideImage)) {
                continue;
            }
            originY += 10;
            
            CGFloat width = sideImage.size.width/2;
            CGFloat height = sideImage.size.height/2;
            
			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.showsTouchWhenHighlighted = YES;
			btn.tag = i;
			btn.frame = CGRectMake((frame.size.width - width)/2, originY, width, height);
			[btn setImage:sideImage forState:UIControlStateNormal];
			[btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:btn];
            
            originY += width;
            
            newPoint[i] = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.size.width - 18, 8, 8, 8)];
            [newPoint[i] setBackgroundColor:[UIColor redColor]];
            [newPoint[i].layer setCornerRadius:4.0];
            [newPoint[i] setHidden:YES];
            [btn addSubview:newPoint[i]];

		}
    }
    return self;
}

#pragma mark 按钮事件
- (void)tabBarButtonClicked:(UIButton *)sender
{
    if (delegate && [delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [delegate tabBar:self didSelectIndex:sender.tag];
    }
}

- (void)setToNewPoint:(NSInteger)which IsHid:(BOOL)toHid{
    if (which < MAXPOINT) {
        if (newPoint[which]) {
            newPoint[which].hidden = toHid;
        }
    }
}
@end
