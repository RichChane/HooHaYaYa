//
//  CustomNavigationItem.m
//  kpkd_iPad
//
//  Created by lkr on 2018/4/9.
//  Copyright © 2018年 lkr. All rights reserved.
//

#import "CustomNavigationItem.h"

@implementation CustomNavigationItem

- (id)initWithTitle:(NSString *)titleStr target:(id)target select:(SEL)function {
    if (self = [super init]) {
        _titleStr = titleStr;
        _itemType = navigationItemTypeTitle;
        _target = target;
        _function = function;
    }
    return self;
}

- (id)initWithImgae:(UIImage *)image target:(id)target select:(SEL)function{
    if (self = [super init]) {
        _image = image;
        _itemType = navigationItemTypeImage;
        _target = target;
        _function = function;
    }
    return self;
}

- (id)initWithCustomView:(UIView *)customView target:(id)target select:(SEL)function{
    if (self = [super init]) {
        _customView = customView;
        _itemType = navigationItemTypeCustomView;
        _target = target;
        _function = function;
    }
    return self;
}

@end
