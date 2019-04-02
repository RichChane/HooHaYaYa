//
//  Proress.m
//  TestDemo
//
//  Created by kiwo on 16/8/9.
//  Copyright © 2016年 kiwo. All rights reserved.
//

#import <IOSKit/Proress.h>

#undef	DEF_SINGLETON
/**
 *  实现单例
 *
 *  @param __class
 *
 *  @return
 */
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__ = nil; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

#define kDefaultBackgroundColor [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]

#define kDefaultCornerRadius 14.0

#define HEX_COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface BaseProressView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes;

- (void)dismiss;

+ (id)progressView;

@end


@implementation BaseProressView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kDefaultBackgroundColor;
        self.layer.cornerRadius = kDefaultCornerRadius;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (progress > 0 &&progress <= 1.0) {
            [self setNeedsDisplay];
        }
    });
    
}

- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes
{
    CGFloat xCenter = self.frame.size.width * 0.5;
    CGFloat yCenter = self.frame.size.height * 0.5;
    
    // 判断系统版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        CGSize strSize = [text sizeWithAttributes:attributes];
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        [text drawAtPoint:CGPointMake(strX, strY) withAttributes:attributes];
    } else {
        CGSize strSize;
        NSAttributedString *attrStr = nil;
        if (attributes[NSFontAttributeName]) {
            strSize = [text sizeWithAttributes:attributes];
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        } else {
            strSize = [text sizeWithAttributes:@{ NSFontAttributeName :[UIFont systemFontOfSize:[UIFont systemFontSize]]}];
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]}];
        }
        
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        
        [attrStr drawAtPoint:CGPointMake(strX, strY)];
    }
}

// 清除指示器
- (void)dismiss
{
    self.progress = 1.0;
}

+ (id)progressView
{
    return [[self alloc] init];
}


@end

@interface CircleProressView : BaseProressView

@property (nonatomic,strong) UILabel *showTextLabel;

-(instancetype)initWithFrame:(CGRect)frame showText:(NSString *)showText;

@end


@implementation CircleProressView

- (void)drawRect:(CGRect)rect
{
    if (self.progress > 0.0) {
        
        //进度圆圈
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGFloat xCenter = rect.size.width * 0.5;
        CGFloat yCenter = 21.0 + 43.0 / 2;
        [HEX_COLOR(0x188bf9) set];
        CGContextSetLineWidth(ctx,3);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
        CGFloat radius = MIN(43.0, 43.0) / 2.0;
        CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
        CGContextStrokePath(ctx);
        
        // 进度数字
        NSString *progressStr = [NSString stringWithFormat:@"%.0f", self.progress * 100];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:12.0];
        attributes[NSForegroundColorAttributeName] = HEX_COLOR(0xffffff);
        [self setCenterProgressText:progressStr withAttributes:attributes];
    }
}

-(instancetype)initWithFrame:(CGRect)frame showText:(NSString *)showText
{
    self = [super initWithFrame:frame];
    if (self) {
        _showTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 100.0 - 26.0,100.0,12.0)];
        [_showTextLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_showTextLabel setTextColor:HEX_COLOR(0xffffff)];
        [_showTextLabel setText:showText];
        [_showTextLabel setTextAlignment:NSTextAlignmentCenter];
        [_showTextLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_showTextLabel];
    }
    return self;
}

-(void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes
{
    if (_showTextLabel.text.length == 0) {
        [super setCenterProgressText:text withAttributes:attributes];
        return;
    }
    CGFloat xCenter = self.frame.size.width * 0.5;
    CGFloat yCenter = 21.0 + 43.0 / 2;
    
    // 判断系统版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        CGSize strSize = [text sizeWithAttributes:attributes];
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        [text drawAtPoint:CGPointMake(strX, strY) withAttributes:attributes];
    } else {
        CGSize strSize;
        NSAttributedString *attrStr = nil;
        if (attributes[NSFontAttributeName]) {
            strSize = [text sizeWithAttributes:attributes];
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        } else {
            strSize = [text sizeWithAttributes:@{ NSFontAttributeName :[UIFont systemFontOfSize:[UIFont systemFontSize]]}];
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]}];
        }
        
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        
        [attrStr drawAtPoint:CGPointMake(strX, strY)];
    }
}

@end


@interface Proress ()
{
    UIWindow *window;
    UIView *_shadowView;
}

@property (nonatomic,strong) CircleProressView *progressView;

@end


@implementation Proress

DEF_SINGLETON(Proress)

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.4;
    }
    
    if (_progressView == nil) {
        _progressView = [[CircleProressView alloc] initWithFrame:CGRectMake(0, 0, 100.0, 100.0) showText:nil];
        _progressView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
        _progressView.layer.zPosition = INT8_MAX;
    }
}

-(void)show
{
    [self setUI];
    window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[[UIApplication sharedApplication] delegate] window];
    }
    [window addSubview:_shadowView];
    [window addSubview:_progressView];
}

-(void)showText:(NSString *)text
{
    [self setUI];
    _progressView.showTextLabel.text = text;
}

-(void)setProress:(CGFloat)proress
{
    _progressView.progress = proress;
}

-(void)dismiss
{
    [_progressView removeFromSuperview];
    _progressView = nil;
    [_shadowView removeFromSuperview];
    _shadowView = nil;
}

@end
