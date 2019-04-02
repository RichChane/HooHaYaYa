//
//  SegmentButton.m
//  kpkd
//
//  Created by gzkp on 2017/12/21.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "SegmentButton.h"
#import "NSString+Size.h"
#import "GeneralConfig.h"

@interface SegmentButton()

@property (nonatomic,strong) UIImageView *showImageView;


@end

@implementation SegmentButton

- (id)initLeftRightWithFrame:(CGRect)frame image:(UIImage *)image text:(NSString *)text
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.highlighted = NO;
        
        //image
        UIImageView *imv;
        if (image) {
            imv = [[UIImageView alloc]initWithImage:image];
            _showImageView = imv;
            [self addSubview:imv];
        }
        
        CGFloat lastWidth = self.frame.size.width - imv.frame.size.width;
        
        //title
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _textLabel = textLabel;
        textLabel.text = text;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = kUIColorFromRGB(0x3D4245);
        [self addSubview:textLabel];
        textLabel.font = FontSize(16);
        CGSize titleSize = [text sizeWithFont:textLabel.font maxSize:CGSizeMake(999, self.frame.size.height)];
        if (titleSize.width > lastWidth) {
            titleSize.width = lastWidth;
        }
        
        //设置frame
        textLabel.frame = CGRectMake((lastWidth - titleSize.width)/2, 0, titleSize.width, self.frame.size.height);
        if (image) {
            imv.frame = CGRectMake(CGRectGetMaxX(textLabel.frame) + 2, (self.frame.size.height - 8)/2, 8, 8);
        }

    }
    
    return self;
}


- (void)setImageShow:(BOOL)isShow
{
    if (_showImageView) {
        if (isShow) {
            _showImageView.hidden = NO;
            
        }else{
            _showImageView.hidden = YES;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
