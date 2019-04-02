//
//  SelectView.h
//  kp
//
//  Created by gzkp on 2017/6/19.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmChoose)(NSInteger index);

@interface SelectView : UIButton

@property (nonatomic,strong) NSArray *selectList;
@property (nonatomic,copy) ConfirmChoose confirmChoose;
@property (nonatomic,assign) NSInteger chooseIndex;
@property (nonatomic,assign) BOOL isAutoPop;


- (instancetype)initWithItemHeight:(CGFloat)iHeight FullHeight:(CGFloat)fHeight;

- (void)openSelect;

- (void)hideSelect;

@end
