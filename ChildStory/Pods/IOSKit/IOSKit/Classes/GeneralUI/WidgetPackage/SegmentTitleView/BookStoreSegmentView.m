//
//  BookStoreSegmentView.m
//  仿搜狗阅读
//
//  Created by DemoLi on 2017/2/15.
//  Copyright © 2017年 YinTokey. All rights reserved.
//

#import "BookStoreSegmentView.h"
#import "SegmentButton.h"
#import "NSString+Size.h"
#import "GeneralConfig.h"

@interface BookStoreSegmentView()

@property (nonatomic,strong) NSMutableArray *btnArr;
@property (nonatomic,strong) UIScrollView *titleScrollView;
@property (nonatomic,strong) UIView *vernier;

@end

@implementation BookStoreSegmentView
{
    UIColor *_selectTitleColor;
    UIColor *_normalTitleColor;
    UIColor *_backgroundColor;
    
    CGFloat rightImvWidth;
    CGFloat btnWidth;
    CGFloat btnHeight;
}

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray*)titleArr
{
    return [self initWithFrame:frame titleArr:titleArr hasPoint:NO NeedVernier:YES PointImage:nil IsMustThree:NO];
}

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray*)titleArr hasPoint:(BOOL)hasPoint NeedVernier:(BOOL)isNeed PointImage:(UIImage *)pImg IsMustThree:(BOOL)isMustThree
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor whiteColor];
        _selectTitleColor = GC.MC;
        _normalTitleColor = kUIColorFromRGB(0x333333);
        _backgroundColor = GC.CWhite;
        
        _pointImage = pImg;
        
        //scrollview
        UIScrollView *titleScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _titleScrollView = titleScrollView;
        titleScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:titleScrollView];
        
        _btnArr = [NSMutableArray array];
        _titleArr = titleArr;
        
        NSInteger maxCount = titleArr.count>5 ? 5:titleArr.count;
        if (isMustThree) {
            maxCount = maxCount<3 ? 3:maxCount;
        }
        
        btnWidth = SCREEN_WIDTH/maxCount;
        btnHeight = self.frame.size.height ;
        titleScrollView.contentSize = CGSizeMake(btnWidth*titleArr.count, self.frame.size.height);

        for (int i = 0; i < titleArr.count; i ++) {
            
            SegmentButton *btn = [[SegmentButton alloc]initLeftRightWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, btnHeight) image:_pointImage text:titleArr[i]];
            [btn addTarget:self action:@selector(selectTitle:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100 + i;
            [btn setBackgroundColor:_backgroundColor];
            [titleScrollView addSubview:btn];
            
            [_btnArr addObject:btn];
            [btn setImageShow:NO];
        }
        
        //游标
        if (isNeed) {
            UIView *vernier = [[UIView alloc]init];
            _vernier = vernier;
            vernier.frame = CGRectMake(0, self.frame.size.height -  2, 30, 2);
            vernier.backgroundColor = _selectTitleColor;
            [titleScrollView addSubview:vernier];
        } else {
            _vernier = nil;
        }
        
        self.selectedIndex = 0;
        [self chooseOneBtn:_btnArr[0]];
        
    }
    return self;

}

- (void)refreshViewWith:(NSArray *)titleArr selectIndex:(NSInteger)selectIndex
{
    [_btnArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_btnArr removeAllObjects];
    _titleArr = titleArr;
    
    NSInteger maxCount = titleArr.count>5 ? 5:titleArr.count;
    CGFloat btnWidth = SCREEN_WIDTH/maxCount;
    CGFloat btnHeight = self.frame.size.height ;
    _titleScrollView.contentSize = CGSizeMake(btnWidth*titleArr.count, self.frame.size.height);
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        SegmentButton *btn = [[SegmentButton alloc]initLeftRightWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, btnHeight) image:_pointImage text:titleArr[i]];
        [btn addTarget:self action:@selector(selectTitle:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [btn setBackgroundColor:_backgroundColor];
        
        [_titleScrollView addSubview:btn];
        
        [_btnArr addObject:btn];
        
    }
    
    if (selectIndex < _btnArr.count) {
        [self chooseOneBtn:_btnArr[selectIndex]];
    }else{
        [self chooseOneBtn:_btnArr[0]];
    }
    
}

#pragma mark - set data

- (void)setTitleArr:(NSArray *)titleArr
{
    _titleArr = titleArr;
    for (UIButton *btn in _btnArr) {
        [btn removeFromSuperview];
    }
    [_btnArr removeAllObjects];
    
    NSInteger maxCount = titleArr.count>3 ? 3:titleArr.count;
    CGFloat btnWidth = SCREEN_WIDTH/maxCount;
    CGFloat btnHeight = self.frame.size.height - 2;
    _titleScrollView.contentSize = CGSizeMake(btnWidth*titleArr.count, self.frame.size.height);
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        SegmentButton *btn = [[SegmentButton alloc]initLeftRightWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, btnHeight) image:_pointImage text:titleArr[i]];
        [btn addTarget:self action:@selector(selectTitle:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [btn setBackgroundColor:_backgroundColor];
        
        [_titleScrollView addSubview:btn];
        
        [_btnArr addObject:btn];
        
        [btn setImageShow:NO];
    }
    
    [self chooseOneBtn:_btnArr[0]];
    
    self.selectedIndex = 0;
    
}

#pragma mark - action

- (void)selectTitle:(SegmentButton *)sender
{
    [self chooseOneBtn:sender];
    
    if (_selectTitle) {
        _selectTitle(sender.tag - 100);
    }else if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:selectTitleIndex:)]){
        [self.delegate segmentView:self selectTitleIndex:sender.tag - 100];
    }
}

- (void)chooseOneBtn:(SegmentButton*)sender
{
    for (SegmentButton *btn in _btnArr) {
        btn.textLabel.textColor = _normalTitleColor;
        [btn setImageShow:NO];
    }
    sender.textLabel.textColor = _selectTitleColor;
    [sender setImageShow:YES];
    
    _selectedIndex = sender.tag - 100;
    
    if (_vernier) {
        _vernier.center = CGPointMake(sender.center.x - (sender.frame.size.width/2-sender.textLabel.center.x), _vernier.center.y);
    }
    
    if (_titleScrollView.contentSize.width > _titleScrollView.frame.size.width) {
        CGFloat offDistance = _titleScrollView.contentOffset.x - sender.frame.origin.x;
        NSLog(@"%0.2f  vernier:%0.2f  offset:%0.2f",offDistance,sender.frame.origin.x,_titleScrollView.contentOffset.x);
        if (sender.tag == 100) {
            [_titleScrollView setContentOffset:CGPointMake(0, 0)];
        }else if (offDistance  > 0){ //需要算出临界值 0和scrollView.width - 一个itemwidth
            [_titleScrollView setContentOffset:CGPointMake((sender.tag - 100)*btnWidth, 0)];
        }else if (offDistance < -(_titleScrollView.frame.size.width - btnWidth)){// 这个一步的计算有点问题
            
            [_titleScrollView setContentOffset:CGPointMake((sender.tag - 99)*btnWidth - _titleScrollView.frame.size.width, 0)];
        }
    }

}


- (void)setSelectedIndex:(NSInteger)aSelectedIndex
{
    if (self.selectedIndex!=aSelectedIndex)
    {
        _selectedIndex = aSelectedIndex;
        if (_btnArr && [_btnArr count] > 0 && aSelectedIndex < [_btnArr count])
        {
            SegmentButton* sender = [_btnArr objectAtIndex:aSelectedIndex];
            [self selectTitle:sender];
        }
    }
}

//为了让 _titleScrollView 不滚动
- (void)setSetTempSelectedIndex:(NSInteger)tempSelectedIndex
{
    
    if (self.selectedIndex!=tempSelectedIndex)
    {
        _selectedIndex = tempSelectedIndex;
        if (_btnArr && [_btnArr count] > 0 && tempSelectedIndex < [_btnArr count])
        {
            SegmentButton* sender = [_btnArr objectAtIndex:tempSelectedIndex];
            [self selectTitle:sender];
            
        }
    }

    
}

#pragma mark - 设置基础数据

- (void)setBaseStatus:(UIColor *)selectTitleColor normalTitleColor:(UIColor *)normalTitleColor backgroundColor:(UIColor *)backgroundColor
{
    _selectTitleColor = selectTitleColor;
    _normalTitleColor = normalTitleColor;
    _backgroundColor = backgroundColor;
    
    
    [self chooseOneBtn:_btnArr[self.selectedIndex]];

}

- (void)setCurrentMarkShow:(BOOL)isShow Which:(NSInteger)index_
{
    if ([_btnArr count] > index_) {
        SegmentButton* sender = [_btnArr objectAtIndex:index_];
        [sender setImageShow:isShow];
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
