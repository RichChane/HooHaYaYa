//
//  STDoubleWayPickerView.m
//  kpkd
//
//  Created by gzkp on 2018/6/19.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "STDoubleWayPickerView.h"


#import <KPFoundation/KPFoundation.h>
#import <IOSKit/GeneralConfig.h>

@interface STDoubleWayPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@end

@implementation STDoubleWayPickerView
{
    NSInteger _selectPickerIndex;
    
    NSInteger _firPickerCompOne;
    NSInteger _componentTwo_1;
    NSInteger _componentThree_1;
    
    NSInteger _secPickerCompOne;
    NSInteger _componentTwo_2;
    NSInteger _componentThree_2;
}

+ (STDoubleWayPickerView *)createSingleComponentViewDelegate:(id)delegate firstArr:(NSArray*)firstArr
{
    STDoubleWayPickerView *pickerDate = [[STDoubleWayPickerView alloc]initWithComponentNum:1];
    [pickerDate setDelegate:delegate];
    pickerDate.tag = 100;
    pickerDate.firstArr = firstArr;
    [pickerDate selectComponentOne:0 componentTwo:0 componentThree:0];
    
    return pickerDate;
    
}

+ (STDoubleWayPickerView *)createViewWithComponent:(NSInteger)component delegate:(id)delegate firstArr:(NSArray*)firstArr secondDict:(NSDictionary*)secondDict thirdDict:(NSDictionary*)thirdDict
{
    STDoubleWayPickerView *pickerDate = [[STDoubleWayPickerView alloc]initWithComponentNum:component];
    [pickerDate setDelegate:delegate];
    pickerDate.tag = 100;
    pickerDate.secondDict = secondDict;
    pickerDate.firstArr = firstArr;
    [pickerDate selectComponentOne:0 componentTwo:0 componentThree:0];
    
    return pickerDate;

}


#pragma mark - 初始化
- (id)initWithComponentNum:(NSInteger)componentNum
{
    self = [super init];
    if (self) {
        
        self.componentNum = componentNum;
        if (self.componentNum == 0) {
            self.componentNum = 1;
        }
    }
    return self;
}

#pragma mark - --- init 视图初始化 ---
- (void)setupUI {
    
    //    self.title = ML(@"请选择日期");
    
    _heightPickerComponent = 28;
    
    
    UIButton *leftBtn = [UIFactory createbtnWithRect:CGRectMake(15, self.lineView.bottom, SCREEN_WIDTH/3, 30) target:self select:@selector(selectPicker:)];
    _leftBtn = leftBtn;
    leftBtn.tag = 100;
    [leftBtn setTitleColor:GC.MC forState:UIControlStateNormal];
    [self.contentView addSubview:leftBtn];
    [GeneralUIUse AddLineDown:leftBtn Color:GC.LINE LeftOri:0 RightOri:0];
    UIButton *rightBtn = [UIFactory createbtnWithRect:CGRectMake(self.width-15-(SCREEN_WIDTH/3), self.lineView.bottom, SCREEN_WIDTH/3, 30) target:self select:@selector(selectPicker:)];
    _rightBtn = rightBtn;
    rightBtn.tag = 101;
    [rightBtn setTitleColor:kUIColorFromRGBAlpha(0x000000, 0.5) forState:UIControlStateNormal];
    [self.contentView addSubview:rightBtn];
    [GeneralUIUse AddLineDown:rightBtn Color:GC.LINE LeftOri:0 RightOri:0];
    UIImageView *arrowImv = [[UIImageView alloc]initWithImage:ImageName(@"requition_arrow")];
    CGFloat arrowOriginX = CGRectGetMaxX(leftBtn.frame) + ((rightBtn.frame.origin.x-CGRectGetMaxX(leftBtn.frame))-arrowImv.width)/2;
    arrowImv.frame = CGRectMake( arrowOriginX, self.lineView.bottom + (30-arrowImv.height)/2, arrowImv.width, arrowImv.height);
    [self.contentView addSubview:arrowImv];
    
    self.lineView.hidden = YES;
    self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x, self.pickerView.frame.origin.y+30, self.pickerView.width, self.pickerView.height);
    
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    
}

- (void)selectComponentIn:(NSInteger)firstPickerComponent secondPikerComponent:(NSInteger)secondPikerComponent
{
    if (firstPickerComponent < _firstArr.count ) {
        _firPickerCompOne = firstPickerComponent;
        STPikerSelectModel *model = _firstArr[firstPickerComponent];
        [_leftBtn setTitle:model.name forState:UIControlStateNormal];
        [self.pickerView selectRow:firstPickerComponent inComponent:0 animated:NO];
    }
    
    if (secondPikerComponent < _firstArr.count ) {
        _secPickerCompOne = secondPikerComponent;
        STPikerSelectModel *model = _firstArr[secondPikerComponent];
        [_rightBtn setTitle:model.name forState:UIControlStateNormal];
    }
    
}


- (void)selectComponentOne:(NSInteger)componentOne componentTwo:(NSInteger)componentTwo componentThree:(NSInteger)componentThree
{
    if (_selectPickerIndex == 0) {
        _firPickerCompOne = componentOne;
        _componentTwo_1 = componentTwo;
        _componentThree_1 = componentThree;
        
    }else if (_selectPickerIndex == 1){
        _secPickerCompOne = componentOne;
        _componentTwo_2 = componentTwo;
        _componentThree_2 = componentThree;
        
    }

    STPikerSelectModel *model = _firstArr[componentOne];
    [_leftBtn setTitle:model.name forState:UIControlStateNormal];
    [_rightBtn setTitle:model.name forState:UIControlStateNormal];

    [self.pickerView selectRow:componentOne inComponent:0 animated:NO];
    [self.pickerView selectRow:componentTwo inComponent:1 animated:NO];
    //[self.pickerView selectRow:day inComponent:2 animated:NO];
    
}




#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.componentNum;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.width/self.componentNum;
}

- (CGSize)rowSizeForComponent:(NSInteger)component
{
    return CGSizeMake(self.width/self.componentNum, _heightPickerComponent);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _firstArr.count;
    }else if(component == 1) {
        STPikerSelectModel *selectModel = _firstArr[_firPickerCompOne];
        NSArray *monthArr = _secondDict[selectModel.name];
        return monthArr.count;
    }else {
        return _thirdArr.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            if (_selectPickerIndex == 0) {
                _firPickerCompOne = row;
            }else if (_selectPickerIndex == 1){
                _secPickerCompOne = row;
            }
            
            [pickerView reloadComponent:1];
            
            break;
        case 1:
            if (_selectPickerIndex == 0) {
                _componentTwo_1 = row;
            }else if (_selectPickerIndex == 1){
                _componentTwo_2 = row;
            }
            
            //[pickerView reloadComponent:1];
        default:
            break;
    }
    
    
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    STPikerSelectModel *selectModel;
    if (component == 0) {
        selectModel =  _firstArr[row];
    }else if (component == 1){
        STPikerSelectModel *selectModel = _firstArr[_firPickerCompOne];
        NSArray *monthArr = _secondDict[selectModel.name];
        if (monthArr.count <= row ) {
            
        }else{
            selectModel = monthArr[row];
        }
        
    }
    
    NSString *text = selectModel.name? selectModel.name:[NSString stringWithFormat:@"%ld", (long)row + 1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH/self.componentNum, self.heightPickerComponent)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:20]];
    [label setText:text];
    return label;
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    
    if (_selectPickerIndex == 0) {
        STPikerSelectModel *model1 = _firstArr[_firPickerCompOne];
        [_leftBtn setTitle:model1.name forState:UIControlStateNormal];
        [_leftBtn setTitleColor:GC.MC forState:UIControlStateNormal];
        [_rightBtn setTitleColor:kUIColorFromRGBAlpha(0x000000, 0.5) forState:UIControlStateNormal];
    }else{
        STPikerSelectModel *model2 = _firstArr[_secPickerCompOne];
        [_rightBtn setTitle:model2.name forState:UIControlStateNormal];
        [_leftBtn setTitleColor:kUIColorFromRGBAlpha(0x000000, 0.5) forState:UIControlStateNormal];
        [_rightBtn setTitleColor:GC.MC forState:UIControlStateNormal];
    }
    
    
    
}


#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    if (_firPickerCompOne == _secPickerCompOne) {
        [GMUtils showQuickTipWithText:ML(@"请勿选择同一仓库")];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(pickerDate:firstModel:secondModel:)]) {
        
        STPikerSelectModel *firstModel = self.firstArr[_firPickerCompOne];
        STPikerSelectModel *secondModel = self.firstArr[_secPickerCompOne];
        
        [self.delegate pickerDate:self firstModel:firstModel secondModel:secondModel];
    }
    [super selectedOk];
}

- (void)remove
{
    [super remove];
    if ([self.delegate respondsToSelector:@selector(pickerViewSelectCancel:)])
    {
        [self.delegate pickerViewSelectCancel:self];
    }
    
}

- (void)reloadPickerView
{
    [self.pickerView reloadAllComponents];
}

- (void)selectPicker:(UIButton *)sender
{
    _selectPickerIndex = sender.tag-100;
    if (_selectPickerIndex == 0) {
        [_leftBtn setTitleColor:GC.MC forState:UIControlStateNormal];
        [_rightBtn setTitleColor:kUIColorFromRGBAlpha(0x000000, 0.5) forState:UIControlStateNormal];
        [self.pickerView selectRow:_firPickerCompOne inComponent:0 animated:NO];
    }else{
        [_leftBtn setTitleColor:kUIColorFromRGBAlpha(0x000000, 0.5) forState:UIControlStateNormal];
        [_rightBtn setTitleColor:GC.MC forState:UIControlStateNormal];
        [self.pickerView selectRow:_secPickerCompOne inComponent:0 animated:NO];
    }
    
    [self reloadPickerView];
}


@end
