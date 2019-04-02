//
//  GeneralCell.h
//  kp
//
//  Created by zhang yyuan on 2017/5/16.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,GeneralCellEditType)  {
    GeneralCellEditTypeFree = 0,

    GeneralCellEditTypeDelete = 1,              // 删除

    GeneralCellEditTypeBuild = 1 << 1,                // 修改

    GeneralCellEditTypePrint = 1 << 2,                // 打印

    GeneralCellEditTypeCopy = 1 << 3,                // 抄单

    GeneralCellEditTypeOut = 1 << 4,                // 出库

    GeneralCellEditTypeOwn = 1 << 5,                // 收款

    GeneralCellEditTypeDetails = 1 << 6,                // 详情

    GeneralCellEditTypeSameBuy = 1 << 7,                // 同品下单

    GeneralCellEditTypeEdit = 1 << 8,                // 编辑
    
    GeneralCellEditTypeBackup = 1 << 9,          //停用
    
    GeneralCellEditTypeGoodCopy = 1 << 10,          //货品复制
    
    GeneralCellEditTypeWeChatShare = 1 << 11,          //微信分享
    
    GeneralCellEditTypeShare = 1 << 12,          //分享

    //    GeneralCellEditTypeDeleteColor_1 = 1 << 7,             // 删除(颜色定制)

    GeneralCellEditTypeMultiSelect = 1 << 30,                // 多选 （优先级最高）
};

@interface GeneralCellModel : NSObject

@property (readonly) NSInteger cellType;            // 用于存cell的 UI 类型，大类
@property GeneralCellEditType cellEditType;               // 用于存cell的 左滑可编辑类型
@property (readonly) CGRect cellFrame;
@property BOOL canSelect;       // 是否可编辑、或可选中,   默认是YES，表示不可以
@property BOOL isSelectIn;      // 是否处于选中状态

@property (readonly, strong, nonatomic) id cellData;
@property (strong, nonatomic) id editData;          // 编辑数据
@property (strong, nonatomic) id otherMsg;          // 其他数据

@property  NSInteger showModel;          // UI数据展示模式
@property (weak, nonatomic) id tDelegate;

@property NSInteger cellTag;            // 从0开始，下标编号

- (id)initWithType:(NSInteger)type Data:(id)cData Height:(CGFloat)h;         // 初始化

- (void)upToHeight:(CGFloat)h;

@end

@interface GeneralViewCell : UITableViewCell

@property (weak, nonatomic) GeneralCellModel *model;

- (void)buildUI;

- (void)refreshContact:(id)f_model;        // 刷新

- (void)selectedToDo;      // 点中事件

@end
