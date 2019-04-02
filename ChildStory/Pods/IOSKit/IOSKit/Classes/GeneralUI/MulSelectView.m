//
//  MulSelectView.m
//  kpkd
//
//  Created by zhang yyuan on 2017/8/28.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <IOSKit/MulSelectView.h>
#import <KPFoundation/KPFoundation.h>
#import <IOSKit/GeneralConfig.h>

#import "UIFactory.h"

@implementation SelectToModel

- (instancetype)initWithType:(ItemSelectType)type
{
    self = [super init];
    if (self) {
        _typeSelect = type;
        
        if (_typeSelect == ItemSelectTypeMultiselect) {
            _tagSelecte = 0;
        } else {
            _tagSelecte = 1;
        }
    }
    return self;
}

- (void)selectModelToDo:(BOOL)is_select{
    if (is_select) {
        if (_typeSelect == ItemSelectTypeMultiselect) {
            if (_isSelected) {
                if (_tagSelecte) {
                    if (_tagSelecte == 1) {
                        _tagSelecte = 2;
                    }else{
                        _tagSelecte = 1;
                    }
                }else{
                    _tagSelecte = 1;
                }
            }else{
                _tagSelecte = 1;
            }
        }
        
    }else{
        if (_typeSelect == ItemSelectTypeMultiselect) {
            _tagSelecte = 0;
        }
    }
    _isSelected = is_select;
}

@end


#pragma mark - HorizontallySelectView
@interface HorizontallySelectView() {
    CGFloat itemHeight;
    
    UIScrollView *bgView;
    
    NSArray *selectList;
    
    UITapGestureRecognizer *tapGesturRecognizer;
}

@end

@implementation HorizontallySelectView

- (instancetype)initWithView:(UIView *)view {
    if (!view) {
        return nil;
    }
    
    self = [super initWithFrame:view.bounds];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        tapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDo)];
        [self addGestureRecognizer:tapGesturRecognizer];
        
        _isAutoPop = YES;
        
        bgView = nil;
        selectList = nil;
        
        [GeneralConfig ConfigMulSelectView:self];
        
        [view addSubview:self];
    }
    return self;
}

- (UIButton *)defaultItem:(SelectToModel *)one Numb:(NSInteger)i Width:(CGFloat)width{
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, itemHeight * i, width, itemHeight)];
    [itemBtn addTarget:self action:@selector(selectToDo:) forControlEvents:UIControlEventTouchUpInside];
    [itemBtn.titleLabel setFont:FontSize(_defSize)];
    itemBtn.backgroundColor = GC.CWhite;
    [itemBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    itemBtn.tag = 100 + i;
    
    [itemBtn setTitleColor:GC.CBlack forState:UIControlStateNormal];
    [itemBtn setTitleColor:_selectedItemUI forState:UIControlStateSelected];
    
    if (one.subName && one.subName.length) {
        NSString * str = [NSString stringWithFormat:@"%@%@",one.name,one.subName];
        NSRange r1 = [str rangeOfString:one.subName];
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:r1];
        [attStr addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0x7F7F7F) range:r1];
        [itemBtn setAttributedTitle:attStr forState:UIControlStateNormal];
        [itemBtn setAttributedTitle:attStr forState:UIControlStateSelected];
    }else {
        [itemBtn setTitle:one.name forState:UIControlStateNormal];
        [itemBtn setTitle:one.name forState:UIControlStateSelected];
    }
    
    if (one.typeSelect == ItemSelectTypeRadio) {
        
        [itemBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [itemBtn setImageEdgeInsets:UIEdgeInsetsMake((itemBtn.frame.size.height - ASIZE(24))/2, itemBtn.frame.size.width - ASIZE(39), (itemBtn.frame.size.height - ASIZE(24))/2, ASIZE(15))];
        [itemBtn setTitleEdgeInsets:UIEdgeInsetsMake((itemBtn.frame.size.height - ASIZE(24))/2, -ASIZE(9), (itemBtn.frame.size.height - ASIZE(24))/2, ASIZE(15))];
        
        [itemBtn setImage:_radio_check forState:UIControlStateNormal];
        [itemBtn setImage:_radio_check_sel forState:UIControlStateSelected];
        
    } else if (one.typeSelect == ItemSelectTypeMultiselect) {
        
        [itemBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [itemBtn setImageEdgeInsets:UIEdgeInsetsMake((itemBtn.frame.size.height - ASIZE(24))/2, itemBtn.frame.size.width - ASIZE(39), (itemBtn.frame.size.height - ASIZE(24))/2, ASIZE(15))];
        [itemBtn setTitleEdgeInsets:UIEdgeInsetsMake((itemBtn.frame.size.height - ASIZE(24))/2, -ASIZE(9), (itemBtn.frame.size.height - ASIZE(24))/2, ASIZE(15))];
        
        [itemBtn setImage:_arrange_none forState:UIControlStateNormal];
        if (one.tagSelecte == 2) {
            [itemBtn setImage:_arrange_down forState:UIControlStateSelected];
        } else if (one.tagSelecte == 1) {
            [itemBtn setImage:_arrange_up forState:UIControlStateSelected];
        }
        
    }
    
    if (one.isSelected) {
        [itemBtn setSelected:YES];
    }else{
        [itemBtn setSelected:NO];
    }
    
    return itemBtn;
}

- (UIButton *)modelItem_2:(SelectToModel *)one Numb:(NSInteger)i{
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, itemHeight * i, bgView.frame.size.width, itemHeight)];
    [itemBtn setBackgroundColor:GC.CWhite];
    [itemBtn addTarget:self action:@selector(selectToDo:) forControlEvents:UIControlEventTouchUpInside];
    itemBtn.tag = 100 + i;
    
    CGFloat leftHeight = itemBtn.frame.size.height;
    if (one.msg[SelectNameSubtitleKey]) {
        UILabel *nameSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(ASIZE(15), ASIZE(34), ASIZE(100), ASIZE(16.5))];
        [nameSubtitle setBackgroundColor:[UIColor clearColor]];
        [nameSubtitle setTextAlignment:NSTextAlignmentLeft];
        [nameSubtitle setTextColor:kUIColorFromRGB(0x9B9B9B)];
        [nameSubtitle setFont:FontSize(12)];
        [nameSubtitle setText:one.msg[SelectNameSubtitleKey]];
        [itemBtn addSubview:nameSubtitle];
        
        leftHeight -= nameSubtitle.frame.size.height;
    }
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(ASIZE(15), 0, ASIZE(150), leftHeight)];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:FontSize(_defSize)];
    [name setText:one.name];
    [itemBtn addSubview:name];
    
    
    CGFloat rightHeight = itemBtn.frame.size.height;
    if (one.msg[SelectRightSubtitleKey]) {
        UILabel *rightSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(ASIZE(110), ASIZE(34), bgView.frame.size.width - ASIZE(125), ASIZE(16.5))];
        [rightSubtitle setBackgroundColor:[UIColor clearColor]];
        [rightSubtitle setTextAlignment:NSTextAlignmentRight];
        [rightSubtitle setTextColor:kUIColorFromRGB(0x9B9B9B)];
        [rightSubtitle setFont:FontSize(12)];
        [rightSubtitle setText:one.msg[SelectRightSubtitleKey]];
        [itemBtn addSubview:rightSubtitle];
        
        rightHeight -= rightSubtitle.frame.size.height;
    }
    
    if (one.msg[SelectRightMainKey]) {
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(ASIZE(90), 0, bgView.frame.size.width - ASIZE(105), rightHeight)];
        [price setBackgroundColor:[UIColor clearColor]];
        [price setTextColor:kUIColorFromRGB(0x333333)];
        [price setFont:FontSize(20)];
        price.textAlignment = NSTextAlignmentRight;
        [price setText:one.msg[SelectRightMainKey]];
        [itemBtn addSubview:price];
        
    }
    
    if (one.typeSelect == ItemSelectTypeRadio_2) {
        
        [itemBtn setImage:_radio_2_check forState:UIControlStateNormal];
        [itemBtn setImage:_radio_2_check_sel forState:UIControlStateSelected];
        
        [itemBtn setImageEdgeInsets:UIEdgeInsetsMake(itemBtn.frame.size.height - itemBtn.imageView.bounds.size.height, itemBtn.frame.size.width - itemBtn.imageView.bounds.size.width, 0, 0)];
        
    } else if (one.typeSelect == ItemSelectTypeRadio) {
        
        [itemBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [itemBtn setImageEdgeInsets:UIEdgeInsetsMake((itemBtn.frame.size.height - 20)/2, itemBtn.frame.size.width - 40, (itemBtn.frame.size.height - 20)/2, 0)];
        
        [itemBtn setImage:_radio_check forState:UIControlStateNormal];
        [itemBtn setImage:_radio_check_sel forState:UIControlStateSelected];
        
    }
    
    if (one.isSelected) {
        [itemBtn setSelected:YES];
    }else{
        [itemBtn setSelected:NO];
    }
    
    return itemBtn;
}

#pragma mark - action

- (void)openSelectOrgY:(CGFloat)org_y ItemHeight:(CGFloat)iHeight List:(NSArray<SelectToModel *> *)list {
    [self openSelectFrame:CGRectMake(0, org_y, self.frame.size.width, self.frame.size.height - org_y) ItemHeight:iHeight List:list];
}

- (void)openSelectFrame:(CGRect)frame ItemHeight:(CGFloat)iHeight List:(NSArray<SelectToModel *> *)list {
    if (!(list && [list count])) {
        return ;
    }
    
    itemHeight = iHeight;
    
    selectList = [list copy];
    
    if (bgView) {
        return;
    }
    
    bgView = [[UIScrollView alloc]initWithFrame:frame];
    bgView.contentSize = CGSizeMake(bgView.frame.size.width, itemHeight * selectList.count);
    bgView.backgroundColor = _bgColor;
    [self addSubview:bgView];
    
    for (int i = 0; i < selectList.count; i ++) {
        SelectToModel *one = selectList[i];
        UIButton *itemBtn = nil;
        
        if (one.modelSelect == ItemSelectUIModelDefault) {
            itemBtn = [self defaultItem:one Numb:i Width:bgView.frame.size.width];
            
        } else if (one.modelSelect == ItemSelectUIModel_2) {
            itemBtn = [self modelItem_2:one Numb:i];
            
        }
        [bgView addSubview:itemBtn];
        
        if (i != (selectList.count - 1)) {
            [GeneralUIUse AddLineDown:itemBtn Color:GC.LINE LeftOri:15 RightOri:0];
        }
    }
    
    if (bgView) {
        CGRect bgFrame = bgView.frame;
        CGFloat height = bgView.frame.size.height;
        bgFrame.size.height = 0;
        [bgView setFrame:bgFrame];
        bgFrame.size.height = height;
        
        [self setAlpha:0];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             [bgView setFrame:bgFrame];
                             
                             [self setAlpha:1];
                             
                         }
                         completion:^(BOOL finished) {
                             
                         }
         
         ];
    }
}

- (void)hideSelect{
    if (bgView) {
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             [self setAlpha:0];
                             
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }
         
         ];
    }
}

////////////////////////////////////////////
- (void)selectToDo:(UIButton*)sender
{
    NSInteger selectedNum = sender.tag - 100;
    SelectToModel *_chooseModel = selectList[selectedNum];
    
    if (_chooseModel.isSelected && _chooseModel.typeSelect != ItemSelectTypeMultiselect) {
        // 过滤重复点击
        if (_isAutoPop) {
            [self closeDo];
        }
        
        return;
    }
    
    for (NSInteger i = 0; i < [selectList count]; i++) {
        UIButton *item = [bgView viewWithTag:100 + i];
        if (item == sender) {
            [item setSelected:YES];
        }else{
            [item setSelected:NO];
        }
        
        if (_chooseModel == selectList[i]) {
            [selectList[i] selectModelToDo:YES];
        }else{
            [selectList[i] selectModelToDo:NO];
        }
    }
    
    if (_downDelegate && [_downDelegate respondsToSelector:@selector(selectToView:Data:FromModel:)]) {
        [_downDelegate selectToView:self Data:_chooseModel FromModel:YES];
    }
    
    if (_isAutoPop) {
        [self hideSelect];
    }
}

- (void)closeDo{
    if (tapGesturRecognizer) {
        [self removeGestureRecognizer:tapGesturRecognizer];
        tapGesturRecognizer = nil;
    }
    
    [self hideSelect];
    if (_downDelegate && [_downDelegate respondsToSelector:@selector(colseView)]) {
        [_downDelegate colseView];
    }
}

@end


#pragma mark - VerticallySelectView
@interface VerticallySelectView() {
    UIScrollView *sortScroll;
    
    NSArray<SelectToModel *> *sortModelArr;
    
    BOOL needDownDouble;        // 是否需要双击
    BOOL isDownDouble;
    
    UIView *navView;
}

@end

@implementation VerticallySelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [GeneralConfig ConfigMulSelectView:self];
    }
    return self;
}

- (void)beginShowData:(NSArray<SelectToModel *> *)showData {
    [self setBackgroundColor:GC.CWhite];
    
    if (!(showData && [showData count])) {
        return ;
    }
    sortModelArr = showData;
    
    if (sortScroll) {
        [sortScroll removeFromSuperview];
        sortScroll = nil;
    }
    sortScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    [sortScroll setBackgroundColor:[UIColor clearColor]];
    [sortScroll setShowsVerticalScrollIndicator:NO];
    [sortScroll setShowsHorizontalScrollIndicator:NO];
    [self addSubview:sortScroll];
    
    // 先渲染UI，记录UI宽度
    CGFloat btn_width = 0;
    CGFloat btn_start_x = 0;
    
    UIButton *firstBtn = nil;
    BOOL isFirstFire = NO;
    
    for (NSInteger i = 0; i < [sortModelArr count]; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, sortScroll.frame.size.width, sortScroll.frame.size.height)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn.titleLabel setFont:FontSize(17)];
        [btn setTitleColor:kUIColorFromRGB(0x7F7F7F) forState:UIControlStateNormal];
        [btn setTitleColor:GC.MC forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(reorderSelectToDo:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:(i + 100)];
        [btn setTitle:sortModelArr[i].name forState:UIControlStateNormal];
        [btn setTitle:sortModelArr[i].name forState:UIControlStateSelected];
        [sortScroll addSubview:btn];
        [GeneralUIUse AutoCalculationView:btn MaxFrame:btn.frame];
        
        if (sortModelArr[i].typeSelect == ItemSelectTypeMultiselect || sortModelArr[i].typeSelect == ItemSelectTypeRadio) {
            CGRect b_frame = btn.frame;
            b_frame.size.width += 50;
            b_frame.size.height = sortScroll.frame.size.height;
            [btn setFrame:b_frame];
            
            UIImageView *logoBtn = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width - 20, (btn.frame.size.height - 20)/2, 20, 20)];
            logoBtn.contentMode =  UIViewContentModeCenter;
            [logoBtn setTag:1000];
            [btn addSubview:logoBtn];
            
        } else if (sortModelArr[i].typeSelect == ItemSelectTypeRadio_Null) {
            CGRect b_frame = btn.frame;
            b_frame.size.width += 40;
            b_frame.size.height = sortScroll.frame.size.height;
            [btn setFrame:b_frame];
        }
        
        btn_width += btn.frame.size.width;
        
        if (sortModelArr[i].isSelected) {
            firstBtn = btn;
            isFirstFire = sortModelArr[i].isFirstFire;
            sortModelArr[i].isFirstFire = NO;
        }
        
        [self reorderSelectUI:btn];
    }
    
    if (btn_width <= sortScroll.frame.size.width) {
        // 均分布局
        CGFloat more_width = (sortScroll.frame.size.width - btn_width) / [sortModelArr count];
        for (NSInteger i = 0; i < [sortModelArr count]; i++) {
            UIButton *btn = [self viewWithTag:(i + 100)];
            btn_start_x += more_width/2;
            if (btn) {
                CGRect b_frame = btn.frame;
                b_frame.origin.x = btn_start_x;
                [btn setFrame:b_frame];
            }
            
            btn_start_x += btn.frame.size.width + more_width/2;
        }
    }else{
        // 等距布局
        for (NSInteger i = 0; i < [sortModelArr count]; i++) {
            UIButton *btn = [self viewWithTag:(i + 100)];
            if (btn) {
                CGRect b_frame = btn.frame;
                b_frame.origin.x = btn_start_x;
                [btn setFrame:b_frame];
            }
            
            btn_start_x += btn.frame.size.width;
        }
        
        [sortScroll setContentSize:CGSizeMake(btn_width, self.frame.size.height)];
    }
    
    
    if (_isNav) {
        navView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, 16, 2)];
        [navView setBackgroundColor:GC.MC];
        [navView.layer setCornerRadius:1];
    }else{
        navView = nil;
    }
    
    if (isFirstFire) {
        [self reorderSelectToDo:firstBtn];
    }else{
        [self reorderSelectUI:firstBtn];
    }
}

#pragma mark 按钮事件
// 切换排序
- (void)reorderSelectToDo:(UIButton *)sender
{
    NSInteger selTag = sender.tag - 100;
    if ([sortModelArr count] <= selTag) {
        return;
    }
    
    SelectToModel *_chooseModel = sortModelArr[selTag];
    
    if (_chooseModel.isSelected && _chooseModel.typeSelect != ItemSelectTypeMultiselect) {
        // 过滤重复点击
        [self reorderSelectUI:sender];
        return;
    }
    
    for (NSInteger i = 0; i < [sortModelArr count]; i++) {
        UIButton *btn = [self viewWithTag:100 + i];
        if (btn == sender) {
            [btn setSelected:YES];
        }else{
            
            [(UIImageView *)[btn viewWithTag:1000] setImage:nil];
            [btn setSelected:NO];
        }
        
        if (_chooseModel == sortModelArr[i]) {
            [sortModelArr[i] selectModelToDo:YES];
        }else{
            [sortModelArr[i] selectModelToDo:NO];
        }
    }
    
    [self reorderSelectUI:sender];
    
    if (_downDelegate && [_downDelegate respondsToSelector:@selector(selectToView:Data:FromModel:)]) {
        [_downDelegate selectToView:self Data:_chooseModel FromModel:YES];
    }
}
- (void)reorderSelectUI:(UIButton *)sender{
    NSInteger selTag = sender.tag - 100;
    if ([sortModelArr count] <= selTag) {
        return;
    }
    
    _selectIndex = selTag;
    //[sender setSelected:YES];
    
    UIImageView *logo = [sender viewWithTag:1000];
    if (logo) {
        /*
         if (sortModelArr[selTag].tagSelecte == 1) {
         [logo setImage:_arrange_down];
         } else {
         [logo setImage:_arrange_up];
         }
         */
        if (sortModelArr[selTag].isSelected) {
            [logo setImage:_arrange_down];
        } else if (sortModelArr[selTag].isMsg){
            [logo setImage:_arrange_up];
        } else {
            [logo setImage:nil];
        }
    }
    
    if (navView) {
        CGRect navFrame = navView.frame;
        navFrame.origin.x = (sender.frame.size.width - navFrame.size.width) / 2;
        [navView setFrame:navFrame];
        [sender addSubview:navView];
    }
}

@end


#pragma mark - FullSelectView
@interface FullSelectView() {
    
    NSArray<SelectToModel *> *sortModelArr;
    
}

@end

@implementation FullSelectView

- (void)beginShowData:(NSArray<SelectToModel *> *)showData Titile:(NSString *)title NoTip:(NSString *)no_tip {
    [self setBackgroundColor:GC.CWhite];
    
    if (!(showData && [showData count])) {
        return ;
    }
    
    sortModelArr = showData;
    
    self.backgroundColor = GC.CWhite;
    
    CGFloat nowRecordHeight = ASIZE(10);
    
    UIButton *firstBtn = nil;
    BOOL isFirstFire = NO;
    
    if (title && [title length]) {
        UILabel *lab = [UIFactory createLabelWithText:title textColor:kUIColorFromRGB(0x7F7F7F) font:[UIFont fontWithName:@"PingFangSC-Medium" size:ASIZE(15)]];
        lab.frame = CGRectMake(ASIZE(15), nowRecordHeight, ASIZE(200), ASIZE(21));
        [self addSubview:lab];
        
        nowRecordHeight += ASIZE(30);
    }
    
    if ([sortModelArr count]) {
        
        CGFloat nowOrgX = ASIZE(15);
        for (NSInteger i = 0; i < [sortModelArr count]; i++) {
            
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(nowOrgX, nowRecordHeight, 300, ASIZE(30))];
            [btn setBackgroundColor:kUIColorFromRGBAlpha(0xF5F5F5, 1)];
            [btn.titleLabel setFont:FontSize(13)];
            [btn setTitleColor:GC.CBlack forState:UIControlStateNormal];
            [btn setTag:(i + 100)];
            [btn addTarget:self action:@selector(recordSelectToDo:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:sortModelArr[i].name forState:UIControlStateNormal];
            [btn setTitle:sortModelArr[i].name forState:UIControlStateSelected];
            
            [btn setTitleColor:GC.CBlack forState:UIControlStateNormal];
            [btn setTitleColor:GC.MC forState:UIControlStateSelected];
            
            [GeneralUIUse AutoCalculationView:btn MaxFrame:btn.frame];
            
            CGRect bFrame = btn.frame;
            bFrame.size.height = ASIZE(30);
            bFrame.size.width += ASIZE(40);
            [btn setFrame:bFrame];
            [btn.layer setCornerRadius:ASIZE(2)];
            
            
            if (self.frame.size.width < btn.frame.size.width + nowOrgX + ASIZE(15)) {
                nowOrgX = ASIZE(15);
                nowRecordHeight += ASIZE(45);
                
                bFrame.origin.x = nowOrgX;
                bFrame.origin.y = nowRecordHeight;
                [btn setFrame:bFrame];
            }
            [self addSubview:btn];
            
            UIImageView *logoBtn = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width - 14, btn.frame.size.height - 14, 14, 14)];
            [logoBtn setTag:1000];
            [btn addSubview:logoBtn];
            
            
            nowOrgX += btn.frame.size.width + ASIZE(15);
            
            if (sortModelArr[i].isSelected) {
                firstBtn = btn;
                isFirstFire = sortModelArr[i].isFirstFire;
                sortModelArr[i].isFirstFire = NO;
                _selectIndex = i;
            }
            [self recordSelectUI:btn];
        }
        
        nowRecordHeight += ASIZE(48);
        
    }else if(no_tip){
        UILabel *no_lab = [[UILabel alloc] initWithFrame:CGRectMake(0, nowRecordHeight, self.frame.size.width, ASIZE(20))];
        [no_lab setTextColor:[UIColor grayColor]];
        [no_lab setTextAlignment:NSTextAlignmentCenter];
        [no_lab setText:no_tip];
        [no_lab setFont:FontSize(14)];
        [self addSubview:no_lab];
        
        nowRecordHeight += ASIZE(30);
    }
    
    CGRect frame = self.frame;
    frame.size.height = nowRecordHeight;
    self.frame = frame;
    
    if (isFirstFire) {
        [self recordSelectToDo:firstBtn];
    } else {
        [firstBtn setSelected:YES];
        [firstBtn setBackgroundColor:kUIColorFromRGBAlpha(0xFEF5E6, 1)];
        [self recordSelectUI:firstBtn];
    }
}

#pragma mark 按钮事件

- (void)recordSelectToDo:(UIButton *)sender
{
    NSInteger selTag = sender.tag - 100;
    if ([sortModelArr count] <= selTag) {
        return;
    }
    
    SelectToModel *_chooseModel = sortModelArr[selTag];
    
    if (_chooseModel.isSelected) {
        // 过滤重复点击
        return;
    }
    
    for (NSInteger i = 0; i < [sortModelArr count]; i++) {
        UIButton *btn = [self viewWithTag:100 + i];
        if (btn == sender) {
            [btn setSelected:YES];
            [sender setBackgroundColor:kUIColorFromRGBAlpha(0xFEF5E6, 1)];
            
        } else {
            [(UIImageView *)[btn viewWithTag:1000] setImage:nil];
            [btn setSelected:NO];
            
            [btn setBackgroundColor:kUIColorFromRGBAlpha(0xF5F5F5, 1)];
            
        }
        
        if (_chooseModel == sortModelArr[i]) {
            [sortModelArr[i] selectModelToDo:YES];
        }else{
            [sortModelArr[i] selectModelToDo:NO];
        }
    }
    
    _selectIndex = selTag;
    [self recordSelectUI:sender];
    
    if (_downDelegate && [_downDelegate respondsToSelector:@selector(selectToView:Data:FromModel:)]) {
        [_downDelegate selectToView:self Data:_chooseModel FromModel:YES];
    }
}

- (void)recordSelectUI:(UIButton *)sender{
    NSInteger selTag = sender.tag - 100;
    if ([sortModelArr count] <= selTag) {
        return;
    }
    
    UIImageView *logo = [sender viewWithTag:1000];
    if (logo) {
        if (sortModelArr[selTag].isSelected) {
            [logo setImage:_radio_2_check_sel];
        } else if (sortModelArr[selTag].isMsg){
            [logo setImage:_radio_2_check];
        } else {
            [logo setImage:nil];
        }
    }
}

@end
