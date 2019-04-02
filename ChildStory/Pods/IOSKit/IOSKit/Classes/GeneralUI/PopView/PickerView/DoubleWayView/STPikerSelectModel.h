//
//  STPikerSelectModel.h
//  kpkd
//
//  Created by gzkp on 2018/6/19.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol STPikerSelectDelegate <NSObject>
//
//@optional
//
//
//
//@required
//
///**
// 返回操作结果
//
// @param typeData 选中STPikerSelectModel数据
// */
//- (void)pikerSelectData:(id)typeData;
//
//@end

@interface STPikerSelectModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) int64_t selectId;

@property BOOL isSelect;

//@property (nonatomic,assign) id <STPikerSelectDelegate> pikerSelectDelegate;

@end
