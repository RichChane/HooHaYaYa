//
//  MainHandle.m
//  ZYYObjcLib
//
//  Created by zyyuann on 16/2/20.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import <IOSKit/MainNavHandle.h>

#import <IOSKit/DoubleNavController.h>

#import <IOSKit/IOSKit.h>
#import <KPFoundation/KPFoundation.h>

#include <objc/runtime.h>

@interface MainNavHandle()

@end


@implementation MainNavHandle

static bool isInit = NO;     // 单例初始化判断（该类不允许被继承，初始化多个）

+ (MainNavHandle *)Share
{
    static dispatch_once_t predicate;
    static MainNavHandle *checkInstance = nil;
    
    dispatch_once(&predicate, ^{
        isInit = YES;
        checkInstance = [[MainNavHandle alloc] init];
        isInit = NO;
    });
    return checkInstance;
}

- (instancetype)init{
    
    if (isInit) {
        self = [super init];
        if (self){
            
        }
        return self;
    }
    
    NSAssert(isInit , @"MainHandle 类不允许被继承，初始化多个");
    
    return nil;
}

#pragma mark - 外部调用

- (id)initBaseNavBar{
    if (_navController) {
        return _navController;
    }
    
    DoubleNavController *nav = [[DoubleNavController alloc] init];
    nav.unNeedNav = YES;
    
    _navController = [GeneralUIUse buildNavWithViewController:nav];
    
    return _navController;
}

- (void)deallocMain{
//    if (_navController) {
//        [_navController removeFromParentViewController];
//        _navController = nil;
//    }
    if (_navController) {
        [_navController.view setAlpha:0];
        
        [_navController popToRootViewControllerAnimated:NO];
    }
}

- (void)addLeftRightNavControllerSetting:(NSString *)setting{
    if (!(_navController && [[_navController viewControllers] count])) {
        return;
    }
    
    id p_vc = [_navController viewControllers][0];
    if (![p_vc isKindOfClass:[DoubleNavController class]]) {
        return;
    }
    
    NSDictionary *initInfo = FCJsonLocal(setting);
    
    if (!initInfo) {
        return ;
    }
    
    NSArray *navBarItem = [initInfo objectForKey:@"navBarTag"];
    NSString *navScale = [initInfo objectForKey:@"navScale"];
    if (navBarItem && [navBarItem count] == 2) {
        UINavigationController *l_nav = nil;
        UINavigationController *r_nav = nil;
        
        NSString *oneClass = [(NSDictionary *)navBarItem[0] objectForKey:@"Item_Class"];
        if (oneClass) {
            Class kclass = objc_getClass([oneClass UTF8String]);
            if (kclass && [kclass isSubclassOfClass:[GeneralViewController class]]) {
                GeneralViewController *l_vc = [[kclass alloc] init];
                l_vc.isSelfNav = YES;
                l_nav = [GeneralUIUse buildNavWithViewController:l_vc];
                [l_nav.view setFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH * (1 - navScale.floatValue) - 0.5, SCREEN_HEIGHT)];
            }
        }
        
        NSString *otherClass = [(NSDictionary *)navBarItem[1] objectForKey:@"Item_Class"];
        if (otherClass) {
            Class kclass = objc_getClass([otherClass UTF8String]);
            if (kclass && [kclass isSubclassOfClass:[GeneralViewController class]]) {
                GeneralViewController *r_vc = [[kclass alloc] init];
                r_vc.isSelfNav = YES;
                r_nav = [GeneralUIUse buildNavWithViewController:r_vc];
                [r_nav.view setFrame:CGRectMake(SCREEN_WIDTH * (1 - navScale.floatValue), 0.0f, SCREEN_WIDTH * navScale.floatValue, SCREEN_HEIGHT)];
            }
        }
        
        [p_vc addLeftViewController:l_nav RightViewController:r_nav];
    }
}

- (void)pushLeftRightNavControllerSetting:(NSString *)setting RightTag:(NSInteger)rTag{
    [self pushLeftRightNavControllerSetting:setting LeftTag:0 RightTag:rTag];
}
- (void)pushLeftRightNavControllerSetting:(NSString *)setting LeftTag:(NSInteger)lTag RightTag:(NSInteger)rTag {
    if (!_navController) {
        return;
    }
    
    NSDictionary *initInfo = FCJsonLocal(setting);
    
    if (!initInfo) {
        return ;
    }
    
    NSArray *navBarItem = [initInfo objectForKey:@"navBarTag"];
    NSString *navScale = [initInfo objectForKey:@"navScale"];
    if (navBarItem && [navBarItem count] == 2) {
        UINavigationController *l_nav = nil;
        UINavigationController *r_nav = nil;
        
        id leftItem = navBarItem[0];
        if ([leftItem isKindOfClass:[NSDictionary class]]) {
            NSString *oneClass = [leftItem objectForKey:@"Item_Class"];
            if (oneClass) {
                Class kclass = objc_getClass([oneClass UTF8String]);
                if (kclass && [kclass isSubclassOfClass:[GeneralViewController class]]) {
                    GeneralViewController *l_vc = [[kclass alloc] init];
                    l_vc.publicData = [leftItem objectForKey:@"Item_Data"];
                    l_vc.isSelfNav = YES;
                    l_nav = [GeneralUIUse buildNavWithViewController:l_vc];
                    [l_nav.view setFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH * (1 - navScale.floatValue) - 0.5, SCREEN_HEIGHT)];
                }
            }
            
        }else if ([leftItem isKindOfClass:[NSArray class]] && lTag < [leftItem count]){
            NSString *oneClass = [leftItem[lTag] objectForKey:@"Item_Class"];
            if (oneClass) {
                Class kclass = objc_getClass([oneClass UTF8String]);
                if (kclass && [kclass isSubclassOfClass:[GeneralViewController class]]) {
                    GeneralViewController *l_vc = [[kclass alloc] init];
                    l_vc.publicData = [leftItem[lTag] objectForKey:@"Item_Data"];
                    l_vc.isSelfNav = YES;
                    l_nav = [GeneralUIUse buildNavWithViewController:l_vc];
                    [l_nav.view setFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH * (1 - navScale.floatValue) - 0.5, SCREEN_HEIGHT)];
                }
            }
        }
        
        id rightItem = navBarItem[1];
        if ([rightItem isKindOfClass:[NSDictionary class]]) {
            NSString *otherClass = [rightItem objectForKey:@"Item_Class"];
            if (otherClass) {
                Class kclass = objc_getClass([otherClass UTF8String]);
                if (kclass && [kclass isSubclassOfClass:[GeneralViewController class]]) {
                    GeneralViewController *r_vc = [[kclass alloc] init];
                    r_vc.isSelfNav = YES;
                    r_nav = [GeneralUIUse buildNavWithViewController:r_vc];
                    [r_nav.view setFrame:CGRectMake(SCREEN_WIDTH * (1 - navScale.floatValue), 0.0f, SCREEN_WIDTH * navScale.floatValue, SCREEN_HEIGHT)];
                }
            }
            
        }else if ([rightItem isKindOfClass:[NSArray class]] && rTag < [rightItem count]){
            NSString *otherClass = [rightItem[rTag] objectForKey:@"Item_Class"];
            if (otherClass) {
                Class kclass = objc_getClass([otherClass UTF8String]);
                if (kclass && [kclass isSubclassOfClass:[GeneralViewController class]]) {
                    GeneralViewController *r_vc = [[kclass alloc] init];
                    r_vc.isSelfNav = YES;
                    r_nav = [GeneralUIUse buildNavWithViewController:r_vc];
                    [r_nav.view setFrame:CGRectMake(SCREEN_WIDTH * (1 - navScale.floatValue), 0.0f, SCREEN_WIDTH * navScale.floatValue, SCREEN_HEIGHT)];
                }
            }
        }
        
        
        
        DoubleNavController *p_vc = [[DoubleNavController alloc] init];
        p_vc.unNeedNav = YES;
        [p_vc addLeftViewController:l_nav RightViewController:r_nav];
        
        [_navController pushViewController:p_vc animated:YES];
    }
}
- (void)changehLeftRightNavControllerSetting:(NSString *)setting RightTag:(NSInteger)rTag{
    if (!_navController) {
        return;
    }
    
    id p_vc = [[_navController viewControllers] lastObject];
    if (![p_vc isKindOfClass:[DoubleNavController class]]) {
        return;
    }
    
    NSDictionary *initInfo = FCJsonLocal(setting);
    
    if (!initInfo) {
        return ;
    }
    
    NSArray *navBarItem = [initInfo objectForKey:@"navBarTag"];
    NSString *navScale = [initInfo objectForKey:@"navScale"];
    if (navBarItem && [navBarItem count] == 2) {
        UINavigationController *r_nav = nil;
        
        id rightItem = navBarItem[1];
        if ([rightItem isKindOfClass:[NSArray class]] && rTag < [rightItem count]){
            NSString *otherClass = [rightItem[rTag] objectForKey:@"Item_Class"];
            if (otherClass) {
                Class kclass = objc_getClass([otherClass UTF8String]);
                if (kclass && [kclass isSubclassOfClass:[GeneralViewController class]]) {
                    GeneralViewController *r_vc = [[kclass alloc] init];
                    r_vc.isSelfNav = YES;
                    r_nav = [GeneralUIUse buildNavWithViewController:r_vc];
                    [r_nav.view setFrame:CGRectMake(SCREEN_WIDTH * (1 - navScale.floatValue), 0.0f, SCREEN_WIDTH * navScale.floatValue, SCREEN_HEIGHT)];
                }
            }
        }
        
        [(DoubleNavController *)p_vc changeRightViewController:r_nav];
    }
}

- (void)sendToRightNavMessage:(id)msg {
    id p_vc = [_navController topViewController];
    if (![p_vc isKindOfClass:[DoubleNavController class]]) {
        return;
    }
    
    [(GeneralViewController *)[((DoubleNavController *)p_vc).rightViewController topViewController] receiveMessage:msg];
}

- (void)sendToLeftNavMessage:(id)msg {
    id p_vc = [_navController topViewController];
    if (![p_vc isKindOfClass:[DoubleNavController class]]) {
        return;
    }
    
    [(GeneralViewController *)[((DoubleNavController *)p_vc).leftViewController topViewController] receiveMessage:msg];
}

@end
