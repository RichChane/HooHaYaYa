//
//  GeneralModelHF.h
//  kp
//
//  Created by zhang yyuan on 2017/6/7.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralViewModel : NSObject

@property (readonly) NSInteger viewType;          // 用于存table 的 Header\Foot的 UI 类型，大类
@property NSInteger viewEditType;         // 可操作 标记
@property (readonly) CGFloat height;

@property (readonly, strong, nonatomic) id viewData;        // 展示用数据（尽量静态不可变）
@property (strong, nonatomic) id editData;             // 编辑数据
@property (strong, nonatomic) id otherMsg;             // 其他数据

@property (weak, nonatomic) id viewDelegate;

- (id)initWithType:(NSInteger)type Data:(id)data Height:(CGFloat)h;         // 初始化

- (void)upToHeight:(CGFloat)h;

@end



@interface GeneralToView : UIView {
    GeneralViewModel *model;
}

- (void)buildUI:(id)data;

- (void)refreshContact:(GeneralViewModel *)f_Model;        // 刷新

- (GeneralViewModel *)getHFModel;

@end
