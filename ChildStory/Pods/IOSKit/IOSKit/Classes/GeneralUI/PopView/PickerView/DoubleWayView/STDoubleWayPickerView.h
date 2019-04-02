//
//  STDoubleWayPickerView.h
//  kpkd
//
//  Created by gzkp on 2018/6/19.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "STPickerView.h"
#import "STPikerSelectModel.h"

@protocol STDoubleWayPickerViewDelegate;

@interface STDoubleWayPickerView : STPickerView

/** 3.中间选择框的高度，default is 28*/
@property (nonatomic,assign) CGFloat heightPickerComponent;

/** 第一列数组 */
@property (nonatomic,strong) NSArray *firstArr;
/** 第一列key对应的第二列数组 */
@property (nonatomic,strong) NSArray *thirdArr;
/** 第二列key对应的第三列数组 */
@property (nonatomic,strong) NSDictionary *secondDict;
/** 代理回调  */
@property(nonatomic, weak)id <STDoubleWayPickerViewDelegate>delegate;


/** 初始化 单一Component */
+ (STDoubleWayPickerView *)createSingleComponentViewDelegate:(id)delegate firstArr:(NSArray*)firstArr;
/** 初始化 多个Component */
+ (STDoubleWayPickerView *)createViewWithComponent:(NSInteger)component delegate:(id)delegate firstArr:(NSArray*)firstArr secondDict:(NSDictionary*)secondDict thirdDict:(NSDictionary*)thirdDict;

/** 初始选择 */
- (void)selectComponentOne:(NSInteger)componentOne componentTwo:(NSInteger)componentTwo componentThree:(NSInteger)componentThree;
/** 初始选择 */
- (void)selectComponentIn:(NSInteger)firstPickerComponent secondPikerComponent:(NSInteger)secondPikerComponent;

@end


@protocol  STDoubleWayPickerViewDelegate<STPickerViewDelegate>

- (void)pickerDate:(STPickerView *)pickerDate firstModel:(STPikerSelectModel*)firstModel secondModel:(STPikerSelectModel *)secondModel;

@end
