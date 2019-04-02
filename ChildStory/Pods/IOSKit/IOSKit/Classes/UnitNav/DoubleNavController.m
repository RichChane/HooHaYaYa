//
//  KPStackedContainerViewController.m
//  ViewStack
//
//  Created by lkr on 2018/4/3.
//  Copyright © 2018年 lkr. All rights reserved.
//

#import <IOSKit/DoubleNavController.h>

#import <IOSKit/IOSKit.h>

@implementation DoubleNavController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:GC.LINE];
    [self.view setAlpha:0];
}

- (BOOL)addLeftViewController:(UINavigationController *)lController RightViewController:(UINavigationController *)rController{
    [self.view setAlpha:1];
    
    if (!(lController && rController)) {
        return NO;
    }
    
    _leftViewController = lController;
    _rightViewController = rController;
    
    
    [self addChildViewController:lController];
    [self.view addSubview:lController.view];
    
    [self addChildViewController:rController];
    [self.view addSubview:rController.view];
    
    return YES;
}

- (void)changeRightViewController:(UINavigationController *)rController{
    if (rController) {
        if (_rightViewController) {
            [_rightViewController.view removeFromSuperview];
            [_rightViewController removeFromParentViewController];
        }
        
        _rightViewController = rController;
        
        [self addChildViewController:rController];
        [self.view addSubview:rController.view];
    }
}

@end
