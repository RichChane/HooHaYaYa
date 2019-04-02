//
//  GeneralSection.h
//  kp
//
//  Created by zhang yyuan on 2017/5/17.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GeneralSectionModel : NSObject

@property (readonly) NSInteger sectionType;     // 用于存section的 UI 类型，大类
@property (readonly) CGFloat headHeight;
@property (readonly) CGFloat footHeight;

@property (readonly, strong, nonatomic) id sectionData;
@property (strong, nonatomic) id editData;          // 编辑数据

@property (weak, nonatomic) id toDelegate;


- (id)initWithType:(NSInteger)type Data:(id)cData HeadHeight:(CGFloat)hheight FootHeight:(CGFloat)fheight;         // 初始化

@end


@interface GeneralViewSection : UITableViewHeaderFooterView

@property (weak, nonatomic) GeneralSectionModel *model;

- (void)buildUI;

- (void)refreshContact:(id)f_model;        // 刷新


@end
