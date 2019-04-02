//
//  SelectView.m
//  kp
//
//  Created by gzkp on 2017/6/19.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "SelectView.h"
#import "GeneralConfig.h"
#import "GeneralUIUse.h"

@interface SelectView(){
    CGFloat itemHeight;
    
    UIView *bgView;
}

@property (nonatomic,strong) NSMutableArray *selectImVArray;

@end


@implementation SelectView

- (instancetype)initWithItemHeight:(CGFloat)iHeight FullHeight:(CGFloat)fHeight
{
    self = [super initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, fHeight)];
    if (self) {
        
        [self setBackgroundColor:kUIColorFromRGBAlpha(0x000000, 0.5)];
        
        [self addTarget:self action:@selector(ddddddd) forControlEvents:UIControlEventTouchUpInside];
        
        itemHeight = iHeight;
        self.clipsToBounds = YES;
        _selectList = nil;
        _chooseIndex = 0;
        _isAutoPop = YES;
        
        bgView = nil;
    }
    return self;
}


- (void)createSelectListView
{
    if (bgView) {
        return;
    }
    bgView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, itemHeight * _selectList.count)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    _selectImVArray = [NSMutableArray array];
    for (int i = 0; i < _selectList.count; i ++) {
        
        UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, itemHeight*i, SCREEN_WIDTH, itemHeight)];
        [itemBtn addTarget:self action:@selector(selectLanguage:) forControlEvents:UIControlEventTouchUpInside];
        itemBtn.tag = 100+i;
        [bgView addSubview:itemBtn];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, itemHeight)];
        titleLabel.font = FontSize(16);
        titleLabel.textColor = kUIColorFromRGB(0x3D4245);
        titleLabel.text = _selectList[i];
        [itemBtn addSubview:titleLabel];
        
        UIImageView *selectImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_selected"]];
        selectImV.frame = CGRectMake(SCREEN_WIDTH - 15 - selectImV.image.size.width, (itemBtn.frame.size.height - selectImV.frame.size.height)/2, selectImV.frame.size.width, selectImV.frame.size.height);
        [itemBtn addSubview:selectImV];
        if (i != _chooseIndex) {
            selectImV.hidden = YES;
        }
        
        if (i != (_selectList.count - 1)) {
            [GeneralUIUse AddLineDown:itemBtn Color:RGB(221,221,221) LeftOri:15 RightOri:0];
        }
        
        [_selectImVArray addObject:selectImV];
    }
    
}

#pragma mark - action

- (void)selectLanguage:(UIButton*)sender
{
    NSInteger selectedNum = sender.tag%100;
    NSLog(@"%@",_selectList[selectedNum]);
    
    for (UIImageView *item in _selectImVArray) {
        item.hidden = YES;
    }
    
    UIImageView *selectedItem = _selectImVArray[selectedNum];
    selectedItem.hidden = NO;
    _chooseIndex = sender.tag-100;
    if (self.confirmChoose) {
        self.confirmChoose(_chooseIndex);
    }
    
    if (_isAutoPop) {
        [self hideSelect];
    }
}

- (void)openSelect{
    [self createSelectListView];
    
    if (bgView) {
        CGRect bgFrame = bgView.frame;
        bgFrame.origin.y = -bgFrame.size.height;
        [bgView setFrame:bgFrame];
        bgFrame.origin.y = 0;
        
        [self setAlpha:0];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             [bgView setFrame:bgFrame];
                             
                             [self setAlpha:1];
                             
                         }
                         completion:^(BOOL finished){
                             
                         }
         
         ];
    }
}

- (void)hideSelect{
    if (bgView) {
        CGRect bgFrame = bgView.frame;
        bgFrame.origin.y = -bgFrame.size.height;
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             [bgView setFrame:bgFrame];
                             
                         }
                         completion:^(BOOL finished){
                             [self removeFromSuperview];
                         }
         
         ];
    }
}

- (void)ddddddd{
    [self hideSelect];
    
    if (self.confirmChoose) {
        self.confirmChoose(-1);
    }
}

@end
