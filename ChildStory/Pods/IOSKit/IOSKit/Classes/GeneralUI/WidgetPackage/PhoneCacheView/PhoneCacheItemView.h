//
//  PhoneCacheItemView.h
//  kpkd
//
//  Created by gzkp on 2017/7/18.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneCacheItemView : UIView

@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) UIImage *userHeaderImg;
@property (nonatomic,strong) NSString *userHeaderUrl;
@property (nonatomic,strong) NSString *userName;

@property (nonatomic,strong) UIButton *deleteBtn;


- (void)addDelTarget:(id)target action:(SEL)action;

- (void)addChooseTarget:(id)target action:(SEL)action;

@end


