//
//  MainHandle.m
//  ZYYObjcLib
//
//  Created by zyyuann on 16/2/20.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import <IOSKit/MainHandle.h>

#import <IOSKit/IOSKit.h>
#import <KPFoundation/KPFoundation.h>

#import <IOSKit/LeveyTabBarController.h>

#include <objc/runtime.h>

@interface MainHandle(){
    LeveyTabBarController *barController;
    
    LeveyTabBarController *otherController;
    
    NSInteger localizableType;      // 语言类型
}

@end


@implementation MainHandle

static bool isInit = NO;     // 单例初始化判断（该类不允许被继承，初始化多个）

+ (MainHandle *)Share
{
    static dispatch_once_t predicate;
    static MainHandle *checkInstance = nil;
    
    dispatch_once(&predicate, ^{
        isInit = YES;
        checkInstance = [[MainHandle alloc] init];
        isInit = NO;
    });
    return checkInstance;
}

- (instancetype)init{
    
    if (isInit) {
        self = [super init];
        if (self){
            barController = nil;
            
            localizableType = 0;
            
            _ballBack = nil;
        }
        return self;
    }
    
    NSAssert(isInit , @"MainHandle 类不允许被继承，初始化多个");
    
    return nil;
}

#pragma mark - 外部调用

// json文件模式初始化
- (id)initTabBarWithSuffix:(NSString *)suffix Main:(BOOL)isMain {
    
    if (barController && isMain) {
        [barController removeAllController];
        barController = nil;
    }else if (otherController && !isMain){
        [otherController removeAllController];
        otherController = nil;
    }
    
    if (!suffix) {
        suffix = @"TabBarSetting.json";
    }
    NSDictionary *initInfo = FCJsonLocal(suffix);
    if (!initInfo) {
        return nil;
    }
    
    NSArray *tabBarItem = [initInfo objectForKey:@"tabBarTag"];
    
    NSMutableArray *controllItem = [[NSMutableArray alloc]initWithCapacity:5];
    
    for (NSInteger i = 0; tabBarItem && i < [tabBarItem count]; i++) {
        NSString *oneClass = [(NSDictionary *)tabBarItem[i] objectForKey:@"Item_Class"];
        if (oneClass) {
            Class kclass = objc_getClass([oneClass UTF8String]);
            if (kclass && [kclass isSubclassOfClass:[GeneralViewController class]]) {
                GeneralViewController *controll = [[kclass alloc] init];
                controll.needBar = YES;
                
                if (isMain) {
                    controll.typeBar = 0;
                    [controllItem addObject:[GeneralUIUse buildNavWithViewController:controll]];
                } else {
                    controll.typeBar = 1;
                    [controllItem addObject:[GeneralUIUse buildNavWithViewController:controll]];
                }
            }
        }
    }
    
    UIImage *bgImage = nil;
    if (GC.deviceType == GeneralDeviceTypeIphoneX) {
        bgImage = [GeneralUIUse GetImageLocal:[initInfo objectForKey:@"tabBarImage_X"] BundleResource:@"ZYYLibBundle"];
    } else {
        bgImage = [GeneralUIUse GetImageLocal:[initInfo objectForKey:@"tabBarImage"] BundleResource:@"ZYYLibBundle"];
    }
    
    LeveyTabBarController *barVC = [[LeveyTabBarController alloc] initWithViewControllers:controllItem BarImage:tabBarItem BarBgImage:bgImage];
    if (isMain) {
        barVC.unNeedNav = YES;
        barVC.typeBar = 0;
        barController = barVC;
        
    }else{
        barVC.unNeedNav = YES;
        barVC.typeBar = 1;
        otherController = barVC;
    }
    
    return barVC;
}

- (void)deallocMain{
    if (barController) {
        [barController removeAllController];
        barController = nil;
    }
}

// 添加红的监控(移除功能)
- (void)addBallMonitor:(id)item{
    if (barController && item && [item isKindOfClass:[UIView class]]) {
        [barController bulidBallView];
        [barController addBallTag:item];
    }
}

// TabBar 渐变展示
- (void)showBarAnimate:(BOOL)isAnimate{
    if (!barController) {
        return;
    }
    if (isAnimate) {
        [barController.view setAlpha:0];
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [barController.view setAlpha:1.0];
                         }
                         completion:^(BOOL finished){
                         }
         ];
    }else{
        [barController.view setAlpha:1.0];
    }
}

- (void)reloadBarSuffix:(NSString *)suffix Tag:(NSInteger)tag{
    if (barController && barController.myTabBar) {
        NSDictionary *initInfo = nil;
        if (suffix && [suffix length]) {
            suffix = [NSString stringWithFormat:@"TabBarSetting_%@.json" ,suffix];
            initInfo = FCJsonLocal(suffix);
        }else{
            initInfo = FCJsonLocal(@"TabBarSetting.json");
        }
        if (!initInfo) {
            return ;
        }
        
        NSArray *tabBarItem = [initInfo objectForKey:@"tabBarTag"];
        if ([tabBarItem count] > tag) {
            [barController.myTabBar insertTabWithImageDic:tabBarItem[tag] atIndex:tag MaxTag:[tabBarItem count]];
        }
    }
}

// 隐藏或展示bar
- (void)isHideBar:(BOOL)hide{
    if (barController) {
        [barController hidesTabBar:hide animated:YES];
    }
}

- (BOOL)barInView:(UIView *)theView Type:(NSInteger)type{
    if (!theView) {
        return NO;
    }
    if (type == 0 && barController.myTabBar && [[theView subviews] containsObject:barController.myTabBar]) {
        return YES;
    } else if (type == 1 && otherController.myTabBar && [[theView subviews] containsObject:otherController.myTabBar]){
        return YES;
    } else if (type == 1 && barController.myTabBar && [[theView subviews] containsObject:barController.myTabBar]){
        return YES;
    } else {
        return NO;
    }
}

- (void)barBuildToView:(UIView *)theView Type:(NSInteger)type{
    if (!theView) {
        return;
    }
    
    if (type == 1 && otherController){
        CGRect tFrame = otherController.myTabBar.frame;
        tFrame.origin.y = theView.frame.size.height - tFrame.size.height;
        [otherController.myTabBar setFrame:tFrame];
        
        [otherController.myTabBar removeFromSuperview];
        [theView addSubview:otherController.myTabBar];
    } else if (barController) {
        CGRect tFrame = barController.myTabBar.frame;
        tFrame.origin.y = theView.frame.size.height - tFrame.size.height;
        [barController.myTabBar setFrame:tFrame];
        
        [barController.myTabBar removeFromSuperview];
        [theView addSubview:barController.myTabBar];
    }
    
}

- (void)upBarBuildToView:(UIView *)theView{
    if (!theView) {
        return;
    }
    if ([[theView subviews] containsObject:barController.myTabBar]) {
        [theView bringSubviewToFront:barController.myTabBar];
    } else if ([[theView subviews] containsObject:otherController.myTabBar]){
        [theView bringSubviewToFront:otherController.myTabBar];
    }
}
- (UIView *)getBarView:(NSInteger)type{
    if (type == 0 && barController) {
        return barController.myTabBar;
    } else if (type == 1) {
        if (otherController) {
            return otherController.myTabBar;
        } else {
            return barController.myTabBar;
        }
    }
    
    return nil;
}

- (void)selectWhichBar:(NSInteger)wBar Type:(NSInteger)type{
    if (barController && type == 0) {
        barController.selectIndex = wBar;
        
    } else if (otherController && type == 1){
        if (otherController) {
            otherController.selectIndex = wBar;
        } else {
            barController.selectIndex = wBar;
        }
        
    }
}

- (void)setNewPoint:(NSInteger)which IsHid:(BOOL)toHid{
    if (barController) {
        [barController.myTabBar setToNewPoint:which IsHid:toHid];
    }
}

- (void)setNew:(NSInteger)which Numb:(NSString *)numbStr OpenClean:(BOOL)isCleanAll{
    if (barController) {
        if (isCleanAll) {
            [barController bulidBallView];
        }
        [barController.myTabBar setToNew:which Numb:numbStr CleanAll:isCleanAll];
    }
}

- (void)setTitleWithNew:(NSInteger)which TitleStr:(NSString *)titleStr ImageNor:(UIImage *)imageNor ImageSelected:(UIImage *)imageSelected {
    if (barController) {
        [barController.myTabBar setTitleToNew:which Title:titleStr ImageNor:imageNor ImageSelected:imageSelected];
    }
}

- (id)getNowViewController{
    if (barController) {
        return barController.selectedNowController;
    }
    
    return nil;
}

- (id)getShowViewController{
    if (barController) {
        id obj = barController.selectedNowController;
        if (obj == otherController) {
            return otherController.selectedNowController;
        }
        
        return obj;
    }
    
    return nil;
}

//- (UIViewController *)getPresentedViewController
//{
//    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    if (appRootVC && appRootVC.presentedViewController) {
//        appRootVC = appRootVC.presentedViewController;
//    }
//    
//    return appRootVC;
//}

//获取当前屏幕显示的viewcontroller
//- (UIViewController *)getCurrentVC
//{
//    UIViewController *result = nil;
//
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//
//    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
//
//    if ([nextResponder isKindOfClass:[UIViewController class]])
//        result = nextResponder;
//    else
//        result = window.rootViewController;
//
//    return result;
//}

@end
