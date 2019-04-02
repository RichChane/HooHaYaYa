//
//  GeneralSection.m
//  kp
//
//  Created by zhang yyuan on 2017/5/17.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <IOSKit/GeneralModelSection.h>

#import <IOSKit/IOSKit.h>

#pragma mark GeneralSectionModel
@implementation GeneralSectionModel

- (id)initWithType:(NSInteger)type Data:(id)cData HeadHeight:(CGFloat)hheight FootHeight:(CGFloat)fheight{
    _sectionType = type;
    _sectionData = cData;
    
    _editData = nil;
    
    if (hheight > 0) {
        _headHeight = hheight;
    }
    if (fheight > 0) {
        _footHeight =fheight;
    }
    
    self = [super init];
    if (self) {
    }
    return self;
    
}

@end

@implementation GeneralViewSection


- (void)buildUI{};

- (void)refreshContact:(id)f_model{};

@end
