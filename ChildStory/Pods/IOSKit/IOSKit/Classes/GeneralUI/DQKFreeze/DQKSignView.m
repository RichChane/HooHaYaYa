//
//  DQKFreezeView.m
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "DQKSignView.h"

@interface DQKSignView () {
    UIImageView *imgLogo;
}

@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation DQKSignView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imgLogo = nil;
        _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        
        _contentLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _contentLabel.text = content;
}

- (void)setRightIcon:(UIImage *)rIcon {
    if (imgLogo) {
        [imgLogo removeFromSuperview];
        imgLogo = nil;
    }
    if (rIcon) {
        imgLogo = [[UIImageView alloc] initWithImage:rIcon];
        [imgLogo setFrame:CGRectMake(self.frame.size.width - rIcon.size.width - 5, (self.frame.size.height - rIcon.size.height ) / 2, rIcon.size.width, rIcon.size.height)];
        [self addSubview:imgLogo];
    }
    
}

- (void)setTitleColor:(UIColor *)col {
    [_contentLabel setTextColor:col];
}

- (void)upToLoad {
    CGRect frame = _contentLabel.frame;
    frame.size.width = self.frame.size.width - _moveSignSize;
    
    if (_moveSignType == -1) {
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        frame.origin.x = _moveSignSize;
        
    } else if (_moveSignType == 0) {
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        frame.origin.x = 0;
    } else if (_moveSignType == 1) {
        _contentLabel.textAlignment = NSTextAlignmentRight;
        frame.origin.x = 0;
    }
    
    [_contentLabel setFrame:frame];
}

@end
