//
//  CustomNavigationItem.h
//  kpkd_iPad
//
//  Created by lkr on 2018/4/9.
//  Copyright © 2018年 lkr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  
    navigationItemTypeTitle,
    navigationItemTypeImage,
    navigationItemTypeCustomView
    
}NavigationItemType;

/// 给导航栏创建多个按钮时 按钮的封装类
@interface CustomNavigationItem : NSObject

/// 类型  通过此类型创建的按钮
@property (nonatomic, assign) NavigationItemType itemType;

@property (nonatomic, readonly) NSString *titleStr;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) UIView *customView;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL function;

- (id)initWithTitle:(NSString *)titleStr target:(id)target select:(SEL)function;
- (id)initWithImgae:(UIImage *)image target:(id)target select:(SEL)function;
- (id)initWithCustomView:(UIView *)customView target:(id)target select:(SEL)function;

@end
