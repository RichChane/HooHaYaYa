//
//  MulSelectView.h
//  kpkd
//
//  Created by zhang yyuan on 2017/8/28.
//  Copyright © 2017年 kptech. All rights reserved.
//  复合选择

//#define SelectPriceKey      @"SelectPriceKey"         [GeneralUse StrmethodComma:one.msg[SelectPriceKey] FloatingNumber:3]
//#define SelectStockKey      @"SelectStockKey"         [NSString stringWithFormat:@"x %@",]
//#define SelectStockNumb      @"SelectStockNumb"
//#define SelectQuantityUnitIdKey      @"SelectQuantityUnitIdKey"
//#define SelectPriceUnitIdKey      @"SelectPriceUnitIdKey"
//#define SelectDepartmentId      @"SelectDepartmentId"
//#define SelectTimeKey      @"SelectTimeKey"

#define SelectNameSubtitleKey      @"ShowNameSubtitleKey"           // 对应name 的副标题信息
#define SelectRightMainKey      @"SelectRightMainKey"           // 右边 主要信息
#define SelectRightSubtitleKey      @"SelectRightSubtitleKey"       // 右边 的副标题信息


typedef NS_ENUM (NSInteger,ItemSelectType)  {
    ItemSelectTypeFree = 0,
    
    ItemSelectTypeRadio = 1,            // 打勾logo 单状态
    ItemSelectTypeRadio_2 ,            // 右下角打勾 单状态
    ItemSelectTypeRadio_Null ,
    
    ItemSelectTypeMultiselect,          // 向上、向下logo 复合状态
    
    
};

typedef NS_ENUM (NSInteger,ItemSelectUIModel)  {
    ItemSelectUIModelFree = 0,
    
    ItemSelectUIModelDefault = 1,
    ItemSelectUIModel_2,          // 右侧 有双副标题
    
};


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol SelectToDelegate <NSObject>

@optional

- (void)colseView;

@required

/**
 返回操作结果
 
 @param typeData 选中SelectToModel数据
 @param isFromModel 是否来自这里的点击回调
 */
- (void)selectToView:(id)selectView Data:(id)typeData FromModel:(BOOL)isFromModel;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SelectToModel : NSObject

@property(readonly) ItemSelectType typeSelect;           // 选中模式

@property ItemSelectUIModel modelSelect;           // 显示模式

@property(readonly) BOOL isSelected;        // 是否选中
@property BOOL isMsg;              // 是否存有信息（要配合 isSelected 使用）

@property BOOL isFirstFire;     // 是否首次刷新

@property NSInteger fromUI;             // 来自那个组件
@property NSInteger tagSelecte;             // 单个按钮，多次点击记录 （必须先调动 selectModelToDo: 否则tagSelect设置无效）
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *subName;
@property (nonatomic, strong) NSDictionary *msg;        // 其他信息
@property (nonatomic, strong) id selectData;        // 对象信息

@property (nonatomic, assign) int64_t staffId;


- (instancetype)initWithType:(ItemSelectType)type;

- (void)selectModelToDo:(BOOL)is_select;

@end


#pragma mark - 纵向 选择器
@interface HorizontallySelectView : UIView

@property (weak, nonatomic) id<SelectToDelegate> downDelegate;
@property BOOL isAutoPop;            // 自动隐藏界面

@property (nonatomic, strong) UIColor *selectedItemUI;           // 默认UI 颜色
@property (nonatomic, strong) UIColor *bgColor;           // 默认背景色
@property CGFloat defSize;              // 字体大小

@property (nonatomic, strong) UIImage *radio_check;
@property (nonatomic, strong) UIImage *radio_check_sel;

@property (nonatomic, strong) UIImage *radio_2_check;
@property (nonatomic, strong) UIImage *radio_2_check_sel;

@property (nonatomic, strong) UIImage *arrange_none;
@property (nonatomic, strong) UIImage *arrange_down;
@property (nonatomic, strong) UIImage *arrange_up;

- (instancetype)initWithView:(UIView *)view;

- (void)openSelectOrgY:(CGFloat)org_y ItemHeight:(CGFloat)iHeight List:(NSArray<SelectToModel *> *)list;
- (void)openSelectFrame:(CGRect)frame ItemHeight:(CGFloat)iHeight List:(NSArray<SelectToModel *> *)list;

- (void)hideSelect;

@end


#pragma mark - 横向 单行 选择器
@interface VerticallySelectView : UIView

@property NSInteger selectIndex;        // 选中下标
@property CGFloat defSize;              // 字体大小

@property (weak, nonatomic) id<SelectToDelegate> downDelegate;
@property BOOL isNav;       //是否需要底部导航线段

@property (nonatomic, strong) UIImage *arrange_down;
@property (nonatomic, strong) UIImage *arrange_up;

/**
 显示数据

 @param showData 一个存储 SelectToModel 数组，tag=1表示升序、tag=2表示降序
 */
- (void)beginShowData:(NSArray<SelectToModel *> *)showData;

@end


#pragma mark - 横向 平铺 多行 选择器

@interface FullSelectView : UIView

@property NSInteger selectIndex;        // 选中下标

@property (weak, nonatomic) id<SelectToDelegate> downDelegate;

@property (nonatomic, strong) UIImage *radio_2_check;
@property (nonatomic, strong) UIImage *radio_2_check_sel;

/**
 显示数据
 
 @param showData 一个存储 SelectToModel 数组
 @param title 记录头部提示
 @param no_tip 当 showData 空时，要显示的UI
 */
- (void)beginShowData:(NSArray<SelectToModel *> *)showData Titile:(NSString *)title NoTip:(NSString *)no_tip;

@end
