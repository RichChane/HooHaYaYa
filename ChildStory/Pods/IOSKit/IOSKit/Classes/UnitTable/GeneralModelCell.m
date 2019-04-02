//
//  GeneralCell.m
//  kp
//
//  Created by zhang yyuan on 2017/5/16.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <IOSKit/GeneralModelCell.h>

#import <IOSKit/IOSKit.h>

@implementation GeneralCellModel

- (id)initWithType:(NSInteger)type Data:(id)cData Height:(CGFloat)h{
    _cellType = type;
    _cellData = cData;
    
    _editData = nil;
    _canSelect = YES;
    
    _cellFrame = CGRectMake(0, 0, SCREEN_WIDTH, h);
    
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)upToHeight:(CGFloat)h{
    _cellFrame.size.height = h;
}

@end

@implementation GeneralViewCell

// 初始化数据
- (void)buildUI{};

- (void)refreshContact:(id)f_model{};

- (void)selectedToDo{};

@end
