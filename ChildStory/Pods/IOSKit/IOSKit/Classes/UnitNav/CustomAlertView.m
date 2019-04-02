//
//  CustomAlertView.m
//  kpkd_iPad
//
//  Created by lkr on 2018/4/13.
//  Copyright © 2018年 lkr. All rights reserved.
//

#import <IOSKit/CustomAlertView.h>
#import <IOSKit/IOSKit.h>
#import <KPFoundation/KPFoundation.h>

@interface CustomAlertView()

/// 背景半透明视图
@property (nonatomic, strong) UIView * bgView;

/// 默认宽度
@property (nonatomic, assign) CGFloat defWidth;
/// 默认高度
@property (nonatomic, assign) CGFloat defHeight;

@property (nonatomic, assign) CGSize currentSize;

@property (nonatomic, strong) UINavigationController * navi;

/// 每个界面size的数组
@property (nonatomic, strong) NSMutableArray * sizeArray;


@end

static CustomAlertView *alertView = nil;

@implementation CustomAlertView

+ (instancetype)CustomAlertView:(UIView *)supview {
    if (!supview) {
        return nil;
    }
    
    CustomAlertView *view = [CustomAlertView CustomAlert];
    [supview addSubview:view.bgView];
    
    return view;
}
+ (instancetype)CustomAlert {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertView = [[CustomAlertView alloc] init];
    });
    return alertView;
}

/// 释放单例
- (void)destroyInstance {
    
    alertView = nil;
}

- (void)dealloc {
    NSLog(@"%@:----释放了",NSStringFromSelector(_cmd));
}


- (id)init {
    if (self = [super init]) {
        _sizeArray = [NSMutableArray array];
        _defWidth = ASIZE(560);
        _defHeight = ASIZE(370);
    }
    return self;
}

- (void)initWithSize:(CGSize)size CustomView:(UIViewController *)customVC {
    if (!customVC) {
        return;
    }
    
    _currentSize = size;
    
    if (size.width != 0 && size.height != 0) {
        _defWidth = size.width;
        _defHeight = size.height;
    }
    
    NSDictionary * sizeDic = @{@"width":[NSNumber numberWithFloat:_defWidth], @"height":[NSNumber numberWithFloat:_defHeight]};
    [_sizeArray addObject:sizeDic];
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 14;
    self.backgroundColor = [UIColor grayColor];
    self.frame = CGRectMake(0, 0, _defWidth, _defHeight);
    
    [self.bgView addSubview:self];
    self.center = self.bgView.center;
    
    /// 导航栏
    UINavigationController * navi = [[UINavigationController alloc]
                                     initWithRootViewController:customVC];
    self.navi = navi;
    
    [self addSubview:_navi.view];
    
    _navi.view.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
}

#pragma  - dismiss
- (void)dismiss {
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self removeFromSuperview];
    [self.bgView removeFromSuperview];
    [_sizeArray removeAllObjects];
    
    self.navi = nil;
}

#pragma mark - push or pop
- (void)pushToVC:(UIViewController *)viewController Size:(CGSize)size Animation:(BOOL)animation{
    
    if (!self.navi) {
        [self initWithSize:size CustomView:viewController];
        
        return;
    }
    
    if (size.width != 0 && size.height != 0) {
        _defWidth = size.width;
        _defHeight = size.height;
        NSDictionary * sizeDic = @{@"width":[NSNumber numberWithFloat:_defWidth],@"height":[NSNumber numberWithFloat:_defHeight]};
        [_sizeArray addObject:sizeDic];
        
        
        
    }else {
        NSDictionary * sizeDic = [_sizeArray lastObject];
        [_sizeArray addObject:sizeDic];
    }
    
    // 做动画
    [self doAnimationIsPush:YES ViewController:viewController Animation:animation];
}

- (void)pushToVC:(UIViewController *)viewController Animation:(BOOL)animation {
    [self pushToVC:viewController Size:CGSizeMake(_defWidth, _defHeight) Animation:animation];
}

- (void)popToViewControllerAnimation:(BOOL)animation {
    
    [self doAnimationIsPush:NO ViewController:nil Animation:animation];
    
    //[self.navi popViewControllerAnimated:animation];
}

#pragma mark - 做动画
- (void)doAnimationIsPush:(BOOL)isPush ViewController:viewController Animation:(BOOL)animation {
    
    
    if (_sizeArray.count >= 2) {
        CGSize beginSize,endSize;
        NSDictionary * last1Dic = [_sizeArray lastObject];
        NSDictionary * last2Dic = [_sizeArray objectAtIndex:_sizeArray.count - 2];
        CGSize last1Size = CGSizeMake([last1Dic[@"width"] floatValue], [last1Dic[@"height"] floatValue]);
        CGSize last2Size = CGSizeMake([last2Dic[@"width"] floatValue], [last2Dic[@"height"] floatValue]);
        if (isPush) {
            beginSize = last2Size;
            endSize = last1Size;
        }else {
            beginSize = last1Size;
            endSize = last2Size;
        }
        
        WeakSelf;
        [self doAnimationWithBeginSize:beginSize endSize:endSize andAnimationFianish:^{
            
            if (isPush) {
                [weakSelf.navi pushViewController:viewController animated:animation];
            }else {
                [_sizeArray removeLastObject];
                [self.navi popViewControllerAnimated:animation];
            }
            
        }];
    }
    
}

- (void)doAnimationWithBeginSize:(CGSize)beginSize endSize:(CGSize)endSize andAnimationFianish:(void(^)(void))animationFinish {
    
    CGRect beginFrame = self.frame;
    CGFloat endX = beginFrame.origin.x - (endSize.width - beginSize.width)/2;
    CGFloat endY = beginFrame.origin.y - (endSize.height - beginSize.height)/2;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(endX, endY, endSize.width, endSize.height);
    } completion:^(BOOL finished) {
        animationFinish();
    }];
}


#pragma mark - getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = RGBA(0, 0, 0, 0.5);
    }
    return _bgView;
}

@end
