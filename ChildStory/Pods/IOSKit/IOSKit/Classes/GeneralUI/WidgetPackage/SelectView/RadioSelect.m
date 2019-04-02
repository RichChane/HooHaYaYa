//
//  RadioSelect.m
//  kp
//
//  Created by zhang yyuan on 2017/5/23.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "RadioSelect.h"
#import "UIFactory.h"
#import "GeneralConfig.h"

@interface RadioSelect(){
    __weak id<RadioSelectDelegate> rDelegate;
    
    NSArray *radioName;
    
    UIButton *nowReorderBtn;        // 当前选中
}

@end

@implementation RadioSelect

- (instancetype)initWithFrame:(CGRect)frame ShowData:(NSArray *)showData Delegate:(id<RadioSelectDelegate>)delegate{
    if (!(showData && [showData count])) {
        return nil;
    }
    radioName = showData;
    rDelegate = delegate;
    
    nowReorderBtn = nil;
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat btnMar = 15;
        for (NSInteger i = 0; i < [radioName count]; i++) {
            UIButton *btn = [UIFactory createBtnWithTitle:radioName[i] titleColor:[[UIColor blackColor] colorWithAlphaComponent:1] titleFont:FontSize(12) target:self select:@selector(radioSelectToDo:)];
            CGRect frame = btn.frame;
            frame.size.height = 23;
            frame.size.width += 30;
            frame.origin = CGPointMake(btnMar, (self.frame.size.height-btn.frame.size.height)/2);
            btn.frame = frame;
            btnMar = CGRectGetMaxX(btn.frame)+10;
            
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setTag:(i + 1)];
            [self addSubview:btn];
            
            [btn.layer setCornerRadius:2];
            
            if (i == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self radioSelectToDo:btn];
                });
            }
        }
        
        
    }
    return self;

}

#pragma mark 按钮事件

- (void)radioSelectToDo:(UIButton *)sender
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(sender!=obj){
            if([obj isKindOfClass:[UIButton class]]){
                obj.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
                obj.layer.borderWidth = 0.5;
            }
        }else{
            if([obj isKindOfClass:[UIButton class]]){
                obj.layer.borderColor = [UIColor clearColor].CGColor;
                obj.layer.borderWidth = 0;
            }
        }
    }];
    if (nowReorderBtn && nowReorderBtn == sender) {
        if (rDelegate && [rDelegate respondsToSelector:@selector(radioSelectData:Same:)]) {
            [rDelegate radioSelectData:radioName[nowReorderBtn.tag - 1] Same:YES];
        }
    }else{
        for (NSInteger i = 0; i < [radioName count]; i++) {
            UIButton *btn = [self viewWithTag:(i + 1)];
            
            [btn setSelected:NO];
            
            [btn setBackgroundColor:[UIColor clearColor]];
        }
        
        if (sender){
            [sender setSelected:YES];
            nowReorderBtn = sender;
            
            [nowReorderBtn setBackgroundColor:kUIColorFromRGB(0xFF675E)];
        }
        
        if (rDelegate && [rDelegate respondsToSelector:@selector(radioSelectData:Same:)]) {
            [rDelegate radioSelectData:radioName[nowReorderBtn.tag - 1] Same:NO];
        }
    }
    
    
}

- (void)setButtonIndex:(NSInteger)index {
    UIButton *btn = [self viewWithTag:(index + 1)];
    if (btn != nowReorderBtn) {
        
        [nowReorderBtn setSelected:NO];
        [nowReorderBtn setBackgroundColor:[UIColor clearColor]];
        nowReorderBtn.layer.borderWidth = ASIZE(1);
        nowReorderBtn.layer.borderColor = kUIColorFromRGBAlpha(0x000000, 0.2).CGColor;
        
        nowReorderBtn = btn;
        [nowReorderBtn setSelected:YES];
        [nowReorderBtn setBackgroundColor:GC.MC];
        nowReorderBtn.layer.borderWidth = 0;
        nowReorderBtn.layer.borderColor = [UIColor clearColor].CGColor;
        
    }
}

@end
