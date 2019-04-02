//
//  CustomNaviView.m
//  ViewStackOtherCase
//
//  Created by lkr on 2018/4/8.
//  Copyright © 2018年 lkr. All rights reserved.
//

#import <IOSKit/CustomNavView.h>

#import <IOSKit/IOSKit.h>

#define SpaceBetween 15
#define BaseBarTag      99000

/**
 *  image的宽度是24 但是btn的宽度是40  所以要设置左右距离  7
 *  但如果是文字或者view的话  左右距离是15
 */
/// 如果是btn 左边和右边的距离是7
#define SpaceImageLeftOrRight 7

@interface CustomNavView()

@property (nonatomic, strong) UILabel * titleLabel;       // title

@end

@implementation CustomNavView

- (id)initWithWidth:(CGFloat)width Height:(CGFloat)height{
    
    CGRect frame = CGRectMake(0, 0, width, height);
    
    if (self = [super initWithFrame:frame]) {
        [self setAttributesWithColor:nil];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [self addSubview:_titleLabel];
        
    }
    return _titleLabel;
}

#pragma mark - setter
- (void)setCustomTitle:(NSString *)customTitle {
    if (customTitle) {
        [self.titleLabel setText:customTitle];
        [self.titleLabel setTextColor:_defColor];
        [self setTitleLayOut];
    }else {
        [self.titleLabel setText:@""];
    }
}

- (void)setCustomView:(UIView *)cView {
    
    if (cView != _customView) {
        if (_customView) {
            [_customView removeFromSuperview];
        }
        
        _customView = cView;
    }
    
    if (_customView) {
        CGRect cFrame = cView.frame;
        cFrame.origin.y = GC.topBarNormalHeight + (GC.navBarHeight - cFrame.size.height) / 2;
        cFrame.origin.x = 15;
        
        // 获取左边偏移位置
        for (NSInteger i = 9; i >= CustomNavButtonTypeLeft ; i--) {
            UIView *l_view = [self viewWithTag:BaseBarTag + i];
            if (l_view) {
                cFrame.origin.x += CGRectGetMaxX(l_view.frame);
                break;
            }
        }
        
        // 获取右边偏移位置
        for (NSInteger i = 20; i >= CustomNavButtonTypeRight ; i--) {
            UIView *r_view = [self viewWithTag:BaseBarTag + i];
            if (r_view) {
                cFrame.size.width = r_view.origin.x - 15 - cFrame.origin.x;
                break;
            }
        }
        
        [_customView setFrame:cFrame];
        [self addSubview:_customView];
    }
    
}

#pragma mark - 外部方法  生成左右两边的控件

// 通过自定义View生成
- (void)buttonWithView:(UIView *)bView Type:(CustomNavButtonType)type{
    UIView *view = [self viewWithTag:BaseBarTag + type];
    [view removeFromSuperview];
    
    if (!bView) {
        return ;
    }
    
    [bView setTag:BaseBarTag + type];
    CGRect cFrame = bView.frame;
    
    switch (type) {
        case CustomNavButtonTypeLeft:
        {
            if ([bView isKindOfClass:[UIButton class]]) {
                if (((UIButton *)bView).currentImage) {
                    cFrame.origin.x = SpaceImageLeftOrRight;
                }else {
                    cFrame.origin.x = SpaceBetween;
                }
            }else {
                cFrame.origin.x = SpaceBetween;
            }
            
        }
            break;
            
        case CustomNavButtonTypeLeft_2:
        {
            UIView *l_view = [self viewWithTag:BaseBarTag + CustomNavButtonTypeLeft];
            if (l_view) {
                if ([l_view isKindOfClass:[UIButton class]]) {
                    if (((UIButton *)l_view).currentImage) {
                        cFrame.origin.x = l_view.frame.origin.x + l_view.frame.size.width;
                    }else {
                        cFrame.origin.x = SpaceBetween + l_view.frame.origin.x + l_view.frame.size.width;
                    }
                }else {
                    cFrame.origin.x = SpaceBetween + l_view.frame.origin.x + l_view.frame.size.width;
                }
            }
            
        }
            break;
            
        case CustomNavButtonTypeLeft_3:
        {
            UIView *l_2_view = [self viewWithTag:BaseBarTag + CustomNavButtonTypeLeft_2];
            if (l_2_view) {
                if ([l_2_view isKindOfClass:[UIButton class]]) {
                    if (((UIButton *)l_2_view).currentImage) {
                        cFrame.origin.x = l_2_view.frame.origin.x + l_2_view.frame.size.width;
                    }else {
                        cFrame.origin.x = SpaceBetween + l_2_view.frame.origin.x + l_2_view.frame.size.width;
                    }
                }else {
                    cFrame.origin.x = SpaceBetween + l_2_view.frame.origin.x + l_2_view.frame.size.width;
                }
                
            }
            
        }
            break;
            
        case CustomNavButtonTypeRight:
        {
            if ([bView isKindOfClass:[UIButton class]]) {
                if (((UIButton *)bView).currentImage) {
                    cFrame.origin.x = self.frame.size.width - bView.frame.size.width - SpaceImageLeftOrRight;
                }else {
                    cFrame.origin.x = self.frame.size.width - bView.frame.size.width - SpaceBetween;
                }
            }else {
                cFrame.origin.x = self.frame.size.width - bView.frame.size.width - SpaceBetween;
            }
            
        }
            break;
            
        case CustomNavButtonTypeRight_2:
        {
            UIView *r_view = [self viewWithTag:BaseBarTag + CustomNavButtonTypeRight];
            if (r_view) {
                if ([r_view isKindOfClass:[UIButton class]] && ((UIButton *)r_view).currentImage) {
                    cFrame.origin.x = r_view.frame.origin.x - bView.frame.size.width;
                }else {
                    if ([bView isKindOfClass:[UIButton class]] && ((UIButton *)bView).currentImage) {
                        cFrame.origin.x = r_view.frame.origin.x - bView.frame.size.width;
                    }else {
                        cFrame.origin.x = r_view.frame.origin.x - bView.frame.size.width - SpaceBetween;
                    }
                }
                
            }
            
        }
            break;
            
        case CustomNavButtonTypeRight_3:
        {
            UIView *r_2_view = [self viewWithTag:BaseBarTag + CustomNavButtonTypeRight_2];
            if (r_2_view) {
                if ([r_2_view isKindOfClass:[UIButton class]] && ((UIButton *)r_2_view).currentImage) {
                    cFrame.origin.x = r_2_view.frame.origin.x - bView.frame.size.width;
                }else {
                    if ([bView isKindOfClass:[UIButton class]] && ((UIButton *)bView).currentImage) {
                        cFrame.origin.x = r_2_view.frame.origin.x - bView.frame.size.width;
                    }else {
                        cFrame.origin.x = r_2_view.frame.origin.x - bView.frame.size.width - SpaceBetween;
                    }
                }
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
    [bView setFrame:cFrame];
    [self addSubview:bView];
    
}

#pragma mark - 外部方法  生成中间的控件
- (void)titleWithViewItem:(NSObject *)viewItem Type:(CustomNavButtonType)type {
    
    if (type != CustomNavButtonTypeMiddle) {
        return;
    }
    
    UIView *view = [self viewWithTag:BaseBarTag + type];
    if ([view isKindOfClass:[UILabel class]]) {
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    [view removeFromSuperview];
    view = nil;
    
    if (!viewItem) {
        UIView * view = [self viewWithTag:BaseBarTag + type];
        if (view) {
            [view removeFromSuperview];
        }
        return ;
    }
    
    if ([viewItem isKindOfClass:[NSString class]]) {
        self.customTitle = viewItem;
        self.titleLabel.tag = BaseBarTag + type;
    }else if ([viewItem isKindOfClass:[UIImage class]]) {
        
        
        
    }else if ([viewItem isKindOfClass:[UIView class]]) {
        UIView * titleView = (UIView *)viewItem;
        titleView.tag = BaseBarTag + type;
        CGRect sFrame = titleView.frame;
        sFrame.origin.x = self.width/2 - titleView.width/2;
        sFrame.origin.y = GC.topBarNormalHeight + (GC.navBarHeight - sFrame.size.height) / 2;
        titleView.frame = sFrame;
        [self addSubview:titleView];
    }else if ([viewItem isKindOfClass:[UIButton class]]){
        
        UIButton * button = (UIButton *)viewItem;
        button.tag = BaseBarTag + type;
        CGRect sFrame = button.frame;
        sFrame.origin.x = self.width/2 - button.width/2;
        sFrame.origin.y = GC.topBarNormalHeight + (GC.navBarHeight - sFrame.size.height) / 2;
        button.frame = sFrame;
        [self addSubview:button];
    }
}

- (void)setAttributesWithColor:(UIColor *)color{
    if (color) {
        _defColor = color;
    }else{
        _defColor = GC.CBlack;
    }
}

#pragma mark - 自动布局
- (void)setTitleLayOut {
    
    //    UIView * left = self.leftView ? self.leftView:self;
    //    UIView * right = self.rightView ? self.rightView:self;
    
    CGFloat top = self.frame.size.height - GC.navBarHeight;
    
    self.titleLabel.sd_layout
    .topSpaceToView(self, top)
    .heightIs(GC.navBarHeight)
    .centerXEqualToView(self);
    
    
    //    CGFloat viewWidth = self.leftView.width > self.rightView.width ? self.leftView.width : self.rightView.width;
    //    CGFloat width = self.width - viewWidth * 2 - 15 * 4;
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:200];
}

@end
