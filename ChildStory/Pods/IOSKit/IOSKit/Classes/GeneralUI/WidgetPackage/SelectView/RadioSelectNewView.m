//
//  RadioSelectNewView.m
//  kp
//
//  Created by lkr on 2018/8/8.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "RadioSelectNewView.h"
#import "GeneralConfig.h"

@interface RadioSelectNewView(){
    __weak id<RadioSelectNewViewDelegate> rDelegate;
    
    NSArray *radioName;
    
    UIButton *nowReorderBtn;        // 当前选中
    
    CGFloat _space;
}

@end

@implementation RadioSelectNewView

- (instancetype)initWithFrame:(CGRect)frame ShowData:(NSArray *)showData AndSpacing:(CGFloat)space Delegate:(id<RadioSelectNewViewDelegate>)delegate {
    if (!(showData && [showData count])) {
        return nil;
    }
    
    radioName = showData;
    rDelegate = delegate;
    _space = space;
    nowReorderBtn = nil;
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat btnWidth = ((frame.size.width - _space*(radioName.count - 1))/radioName.count);
        for (NSInteger i = 0; i < [radioName count]; i++) {
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(btnWidth + _space), 0, btnWidth, frame.size.height)];
            [btn.titleLabel setFont:FontSize(12)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(radioSelectToDo:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:(i + 1)];
            [btn setTitle:radioName[i] forState:UIControlStateNormal];
            [btn setTitle:radioName[i] forState:UIControlStateSelected];
            [self addSubview:btn];
            
            [btn.layer setCornerRadius:2];
            btn.layer.borderWidth = ASIZE(1);
            btn.layer.borderColor = kUIColorFromRGBAlpha(0x000000, 0.2).CGColor;
            
            if (i == 0) {
                [btn setSelected:YES];
                nowReorderBtn = btn;
                [btn setBackgroundColor:GC.MC];
                btn.layer.borderWidth = 0;
                btn.layer.borderColor = [UIColor clearColor].CGColor;
            }
        }
        
        
    }
    return self;
}


#pragma mark 按钮事件

- (void)radioSelectToDo:(UIButton *)sender
{
    if (nowReorderBtn && nowReorderBtn == sender) {
        if (rDelegate && [rDelegate respondsToSelector:@selector(radioSelectNewViewData:Same:)]) {
            [rDelegate radioSelectNewViewData:radioName[nowReorderBtn.tag - 1] Same:YES];
        }
    }else{
        for (NSInteger i = 0; i < [radioName count]; i++) {
            UIButton *btn = [self viewWithTag:(i + 1)];
            
            [btn setSelected:NO];
            
            [btn setBackgroundColor:[UIColor clearColor]];
            btn.layer.borderWidth = ASIZE(1);
            btn.layer.borderColor = kUIColorFromRGBAlpha(0x000000, 0.2).CGColor;
        }
        
        if (sender){
            [sender setSelected:YES];
            nowReorderBtn = sender;
            
            [nowReorderBtn setBackgroundColor:GC.MC];
            
            nowReorderBtn.layer.borderWidth = 0;
            nowReorderBtn.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
        if (rDelegate && [rDelegate respondsToSelector:@selector(radioSelectNewViewData:Same:)]) {
            [rDelegate radioSelectNewViewData:radioName[nowReorderBtn.tag - 1] Same:NO];
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
