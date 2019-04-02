//
//  ErrorTopLineView.m
//  kpkd
//
//  Created by gzkp on 2017/10/23.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "ErrorTopLineView.h"
#import "GeneralConfig.h"

@interface ErrorTopLineView()

@property (nonatomic,strong) UILabel *contentLabel;


@end


@implementation ErrorTopLineView

- (id)initErrorViewWithFrame:(CGRect)frame errorType:(ErrorType)errorType contentText:(NSString *)contentText
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image;
        if (errorType == ErrorTypExclamation) {
            image = [UIImage imageNamed:@"unupdate"];
            
        }
        
        UIImageView *errorImV = [[UIImageView alloc]initWithImage:image];
        
        UILabel *label  = [[UILabel alloc]init];
        _contentLabel = label;
        label.text = contentText;
        label.font = FontSize(13);
        label.textColor = kUIColorFromRGB(0x645757);
        
        
        self.backgroundColor = kUIColorFromRGB(0xFFDFDF);
        
        errorImV.frame = CGRectMake(15, (self.frame.size.height - errorImV.frame.size.height)/2, errorImV.frame.size.width, errorImV.frame.size.height);
        label.frame = CGRectMake(CGRectGetMaxX(errorImV.frame) + 5, 0, self.frame.size.width - CGRectGetMaxX(errorImV.frame) - 15, 30);
        
        [self addSubview:errorImV];
        [self addSubview:label];
        
    }
    
    return self;
}

- (void)setContentText:(NSString *)contentText
{
    _contentText = contentText;
    _contentLabel.text = contentText;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
