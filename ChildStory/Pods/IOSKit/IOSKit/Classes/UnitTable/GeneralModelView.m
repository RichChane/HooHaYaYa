//
//  GeneralModelHF.m
//  kp
//
//  Created by zhang yyuan on 2017/6/7.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <IOSKit/GeneralModelView.h>

#import <IOSKit/IOSKit.h>

#pragma mark GeneralViewModel
@implementation GeneralViewModel

- (id)initWithType:(NSInteger)type Data:(id)data Height:(CGFloat)h{
    _viewType = type;
    _viewData = data;
    _height = h;
    
    self = [super init];
    if (self) {
        
    }
    return self;
    
}

- (void)upToHeight:(CGFloat)h{
    _height = h;
}

@end

@implementation GeneralToView

- (void)buildUI:(id)data{}

- (void)refreshContact:(GeneralViewModel *)f_Model{}

- (GeneralViewModel *)getHFModel{
    return model;
}

@end
