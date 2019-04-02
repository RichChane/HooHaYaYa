//
//  CustomAlertView.h
//  kpkd_iPad
//
//  Created by lkr on 2018/4/13.
//  Copyright © 2018年 lkr. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 弹窗的自定义View 包括背景和容器  真正的View需要传进来
@interface CustomAlertView : UIView

+ (instancetype)CustomAlertView:(UIView *)supview;
+ (instancetype)CustomAlert;

- (void)pushToVC:(UIViewController *)viewController Size:(CGSize)size Animation:(BOOL)animation;
- (void)pushToVC:(UIViewController *)viewController Animation:(BOOL)animation;

- (void)popToViewControllerAnimation:(BOOL)animation;

- (void)dismiss;

@end
