
//
//  GeneralViewController.m
//  ZYYObjcLib
//
//  Created by zyyuann on 15/12/29.
//  Copyright © 2015年 ZYY. All rights reserved.
//

#import <IOSKit/GeneralViewController.h>

#import <IOSKit/LeveyTabBarController.h>

#import <IOSKit/IOSKit.h>

#define kResultTeams @"resultTeams"
#define kResultContacts @"resultContacts"
#define kResultMessages @"resultMessages"

@implementation GeneralViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _needReload = NO;
        _customNavBar = nil;
        
        openObserver = NO;
        
#ifdef NAVBARMAIN
        _isSelfNav = YES;
#endif
        
    }
    return self;
}

- (id)initWithViewFrame:(CGRect)frame{
    viewFrame = frame;
    
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];// 去掉导航栏返回按钮后面文字
    [self.view setBackgroundColor:GC.BG];
    
    CGFloat h = 0;
    
    if (viewFrame.size.width > 1) {
        [self.view setFrame:viewFrame];
        self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        h = GC.navBarHeight;
        
    } else {
        viewFrame.size.height = SCREEN_HEIGHT;      // 用于兼容可变高度
        
        h = GC.navBarHeight + GC.topBarNormalHeight;
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    if (GC.unLine && self.navigationController) {
        UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
        if (backgroundView && [backgroundView isKindOfClass:[UIView class]]) {
            backgroundView.subviews.firstObject.hidden = YES;
        }
    }
    
    if (_openFrameReload) {
        // 注册监听
        [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        openObserver = YES;
    }
    
    if (_isSelfNav && !_unNeedNav) {
        if (!_customNavBar) {
            if (self.navigationController) {
                _customNavBar = [[CustomNavView alloc] initWithWidth:self.navigationController.view.frame.size.width Height:h];
            }else {
                _customNavBar = [[CustomNavView alloc] initWithWidth:SCREEN_WIDTH Height:h];
            }
            [self.view addSubview:_customNavBar];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSLog(@"当前VC是%@",NSStringFromClass(self.class));
    
    if (_unNeedNav) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }else{
        if (_isSelfNav) {
            [self.navigationController setNavigationBarHidden:YES animated:animated];
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:animated];
        }
    }
    
    [self navigationBarColor:nil TextAttributes:nil Style:NO];
    
    // 适配二级导航
    if ((self.view.frame.size.height == viewFrame.size.height) && !_unNeedNav) {
        if (!_isSelfNav) {
            CGRect frame = self.view.frame;
            frame.origin.y = (GC.topBarNowHeight + GC.navBarHeight);
            frame.size.height -= (GC.topBarNowHeight + GC.navBarHeight);        // 除去nav
            [self.view setFrame:frame];
        }
    }
    
    for (GeneralViewController *obj in self.childViewControllers) {
        if (![obj isKindOfClass:[UINavigationController class]] && !_isSelfNav) {
            [obj.view setFrame:self.view.bounds];
        }
    }
    
    // 判断是否要加载TabBar(如果是根则要加载)
    if (_needBar) {
        if ([[MainHandle Share] getShowViewController] == self) {
            [[MainHandle Share] barBuildToView:self.view Type:_typeBar];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.navigationController && [self.navigationController.viewControllers count] == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }else{
        if (self.navigationController) {
            if (_unGestureRecognizer) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }else{
                self.navigationController.interactivePopGestureRecognizer.enabled = YES;
                self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.navigationController && ![self.navigationController.viewControllers containsObject:self]) {
        [self viewControllerDidPopFromNavigationController];
    }
}

- (void)dealloc{
    _publicDic = nil;
    _publicData = nil;
    
    if (openObserver) {
        [self.view removeObserver:self forKeyPath:@"frame"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

///////////////////////////////////////
- (UIBarButtonItem *)createBarButtonItem:(NSObject *)barButtonItemComponent Color:(UIColor *)color_
{
    if (!barButtonItemComponent) {
        return nil;
    }
    UIBarButtonItem *barButtonItem = nil;
    if ([[barButtonItemComponent class] isSubclassOfClass:[NSString class]]) {
        barButtonItem = [[UIBarButtonItem alloc] initWithTitle:(NSString *)barButtonItemComponent
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:nil];
        
    } else if ([[barButtonItemComponent class] isSubclassOfClass:[UIImage class]]) {
        barButtonItem = [[UIBarButtonItem alloc] initWithImage:(UIImage *)barButtonItemComponent
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:nil];
        
    } else if ([[barButtonItemComponent class] isSubclassOfClass:[UIView class]]) {
        // 对barButtonItemComponent 转Image
        barButtonItem = [[UIBarButtonItem alloc] initWithImage:[GeneralUIUse GetImageFromView:barButtonItemComponent]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:nil];
        
    }
    
    if (barButtonItem) {
        barButtonItem.tintColor = color_;
    }
    
    return barButtonItem;
}

- (UIButton *)createButtonItem:(id)itemComponent Color:(UIColor *)color_
{
    if (!itemComponent) {
        return nil;
    }
    if (!color_) {
        color_ = self.customNavBar.defColor;
    }
    
    UIButton *item = nil;
    if ([itemComponent isKindOfClass:[NSString class]]) {
        item = [[UIButton alloc] initWithFrame:CGRectMake(0, self.customNavBar.frame.size.height - GC.navBarHeight, 100, GC.navBarHeight)];
        [item setTitleColor:color_ forState:UIControlStateNormal];
        [item setTitleColor:[color_ colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];
        
        [item setTitle:itemComponent forState:UIControlStateNormal];
        
        item.titleLabel.font = SIZE_15;
        [GeneralUIUse AutoCalculationView:item MaxFrame:item.frame];
        CGRect frame_ = item.frame;
        frame_.size.height = GC.navBarHeight;
        [item setFrame:frame_];
        
    } else if ([itemComponent isKindOfClass:[UIImage class]]) {
        
        CGFloat w = 0;
        if (((UIImage *)itemComponent).size.width > 40) {
            w = ((UIImage *)itemComponent).size.width;
        } else {
            w = 40;
        }
        
        
        item = [[UIButton alloc] initWithFrame:CGRectMake(0, self.customNavBar.frame.size.height - GC.navBarHeight, w, GC.navBarHeight)];
//        [item setImageEdgeInsets:UIEdgeInsetsMake((GC.navBarHeight - ((UIImage *)itemComponent).size.height)/2, (w - ((UIImage *)itemComponent).size.width)/2, (GC.navBarHeight - ((UIImage *)itemComponent).size.height)/2, (w - ((UIImage *)itemComponent).size.width)/2)];
        [item setImageEdgeInsets:UIEdgeInsetsMake((GC.navBarHeight - ((UIImage *)itemComponent).size.height)/2, 0, (GC.navBarHeight - ((UIImage *)itemComponent).size.height)/2, 0)];
        
        [item setImage:itemComponent forState:UIControlStateNormal];
        
    } else if ([itemComponent isKindOfClass:[UIView class]]) {
        return [self createButtonItem:[GeneralUIUse GetImageFromView:itemComponent] Color:color_];
    }
    
    return item;
}

#pragma mark - Public methods

- (void)navigationBarColor:(UIColor *)barColor TextAttributes:(UIColor *)aColor Style:(BOOL)isWhite{
    if (_isSelfNav) {
        if (barColor) {
            [self.customNavBar setBackgroundColor:barColor];
        }else{
            [self.customNavBar setBackgroundColor:GC.CWhite];
        }
        
        [self.customNavBar setAttributesWithColor:aColor];
        
    } else {
        if (barColor) {
            [self.navigationController.navigationBar setBarTintColor:barColor];
        }else{
            [self.navigationController.navigationBar setBarTintColor:GC.CWhite];
        }
        
        UIFont *font = FontSize(GC.FS);
        if (aColor) {
            self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:aColor};
        }else{
            self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:GC.CBlack};
        }
    }
    
    if (isWhite) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (CGRect)getShowScreen{
    CGRect frame = self.view.bounds;
    
    if (frame.size.height == viewFrame.size.height) {
        if (_unNeedNav) {
            if (_isSelfNav) {
                frame.origin.y = GC.topBarNowHeight;
                frame.size.height -= GC.topBarNowHeight;
                if ([[MainHandle Share] barInView:self.view Type:_typeBar]){
                    frame.size.height -= GC.tabBarHeight;        // 除去Bar
                }
            }
        } else {
            if (_isSelfNav) {
                frame.origin.y = self.customNavBar.frame.size.height;
                frame.size.height -= self.customNavBar.frame.size.height;
                if ([[MainHandle Share] barInView:self.view Type:_typeBar]){
                    frame.size.height -= GC.tabBarHeight;        // 除去Bar
                }
            } else {
                frame.size.height -= (GC.topBarNowHeight + GC.navBarHeight);        // 除去nav
            }
        }
        
    }else{
        if (_unNeedNav) {
            if (_isSelfNav) {
                frame.origin.y = GC.topBarNowHeight;
                frame.size.height = frame.size.height - GC.topBarNowHeight;
                if ([[MainHandle Share] barInView:self.view Type:_typeBar]){
                    frame.size.height -= GC.tabBarHeight;        // 除去Bar
                }
            }else {
                // 这里兼容 一个vc里面放好几个VC的情况
                //frame.size.height = viewFrame.size.height;
            }
        } else if (_isSelfNav) {
            frame.origin.y = self.customNavBar.frame.size.height;
            frame.size.height = frame.size.height - self.customNavBar.frame.size.height;
            if ([[MainHandle Share] barInView:self.view Type:_typeBar]){
                frame.size.height -= GC.tabBarHeight;        // 除去Bar
            }
        }
    }
    
#ifdef TABBARMAIN
    if ([[MainHandle Share] barInView:self.view Type:_typeBar])
        frame.size.height -= GC.tabBarHeight;        // 除去Bar
#endif
    
    return frame;
}

- (void)setCustomTitleStr:(NSString *)customTitleStr {
    if (customTitleStr) {
        _customTitleStr = customTitleStr;
        [self addCustomNavBarTitleViewItem:customTitleStr];
    }else {
        _customTitleStr = customTitleStr;
        [self addCustomNavBarTitleViewItem:nil];
    }
}

- (void)addCustomNavBarTitleViewItem:(NSObject *)titleViewItem {
    if (_isSelfNav) {
        [self.customNavBar titleWithViewItem:titleViewItem Type:CustomNavButtonTypeMiddle];
    }
}

- (void)addLeftBarButtonItem:(NSObject *)barButtonItem
{
    if (_isSelfNav) {
        [self addLeftBarButtonItem:barButtonItem TintColor:kUIColorFromRGB(0x000000)];
    } else {
        [self addLeftBarButtonItem:barButtonItem TintColor:kUIColorFromRGB(0x000000)];
    }
}

- (void)addLeftBarButtonItem:(NSObject *)barButtonItem TintColor:(UIColor *)color
{
    if (_isSelfNav) {
        UIButton *btn = [self createButtonItem:barButtonItem Color:color];
        [btn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.customNavBar buttonWithView:btn Type:CustomNavButtonTypeLeft];
        
    } else {
        if (self.navigationItem) {
            self.navigationItem.leftBarButtonItem = [self createBarButtonItem:barButtonItem Color:color];
            [self.navigationItem.leftBarButtonItem setAction:@selector(leftBarButtonItemClicked:)];
        } else if (((GeneralViewController *)[[MainHandle Share] getNowViewController]).navigationItem){
            ((GeneralViewController *)[[MainHandle Share] getNowViewController]).navigationItem.leftBarButtonItem = [self createBarButtonItem:barButtonItem Color:color];
            [((GeneralViewController *)[[MainHandle Share] getNowViewController]).navigationItem.leftBarButtonItem setAction:@selector(leftBarButtonItemClicked:)];
        }
    }
}

- (void)addLeft2ButtonItem:(NSObject *)rightButtonItem{
    if (_isSelfNav) {
        UIButton *btn = [self createButtonItem:rightButtonItem Color:kUIColorFromRGB(0x000000)];
        [btn addTarget:self action:@selector(left2ButtonItemClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.customNavBar buttonWithView:btn Type:CustomNavButtonTypeLeft_2];
    }
}

- (void)addRightBarButtonItem:(NSObject *)barButtonItem {
    if (_isSelfNav) {
        [self addRightBarButtonItem:barButtonItem TintColor:kUIColorFromRGB(0x000000)];
    } else {
        [self addRightBarButtonItem:barButtonItem TintColor:kUIColorFromRGB(0x000000)];
    }
}
- (void)addRightBarButtonItem:(NSObject *)barButtonItem TintColor:(UIColor *)color{
    if (_isSelfNav) {
        UIButton *btn = [self createButtonItem:barButtonItem Color:color];
        [btn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.customNavBar buttonWithView:btn Type:CustomNavButtonTypeRight];
        
    } else {
        if (self.navigationItem) {
            right1 = [self createBarButtonItem:barButtonItem Color:color];
            self.navigationItem.rightBarButtonItem = right1;
            [self.navigationItem.rightBarButtonItem setAction:@selector(rightBarButtonItemClicked:)];
        } else if (((GeneralViewController *)[[MainHandle Share] getNowViewController]).navigationItem){
            ((GeneralViewController *)[[MainHandle Share] getNowViewController]).navigationItem.rightBarButtonItem = [self createBarButtonItem:barButtonItem Color:color];
            [((GeneralViewController *)[[MainHandle Share] getNowViewController]).navigationItem.rightBarButtonItem setAction:@selector(rightBarButtonItemClicked:)];
        }
    }
}

- (void)addRight2ButtonItem:(NSObject *)rightButtonItem {
    if (_isSelfNav) {
        if (rightButtonItem) {
            UIButton *btn = [self createButtonItem:rightButtonItem Color:kUIColorFromRGB(0x000000)];
            [btn addTarget:self action:@selector(right2ButtonItemClicked:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.customNavBar buttonWithView:btn Type:CustomNavButtonTypeRight_2];
            right2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }else {
            right2 = nil;
        }
    } else {
        if (rightButtonItem) {
            
            UIButton *rightBtn2 = [self createButtonItem:rightButtonItem Color:kUIColorFromRGB(0x000000)];
            rightBtn2.tag = 1140;
            [rightBtn2 setImage:(UIImage *)rightButtonItem forState:UIControlStateNormal];
            [rightBtn2 addTarget:self action:@selector(right2ButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            right2 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn2];
            
        }else{
            
            right2 = nil;
        }
        
        NSMutableArray *rightBtnArray = [NSMutableArray array];
        if (right1) [rightBtnArray addObject:right1];
        if (right2) [rightBtnArray addObject:right2];
        if (right3) [rightBtnArray addObject:right3];
        self.navigationItem.rightBarButtonItems = rightBtnArray;
        
    }
}

- (void)addRight3ButtonItem:(NSObject *)rightButtonItem {
    if (_isSelfNav) {
        if (rightButtonItem) {
            UIButton *btn = [self createButtonItem:rightButtonItem Color:kUIColorFromRGB(0x000000)];
            [btn addTarget:self action:@selector(right3ButtonItemClicked:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.customNavBar buttonWithView:btn Type:CustomNavButtonTypeRight_3];
            right3 = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }else {
            right3 = nil;
        }
        
    }else {
        if (rightButtonItem) {
            UIButton *rightBtn3 = [self createButtonItem:rightButtonItem Color:kUIColorFromRGB(0x000000)];
            rightBtn3.tag = 1150;
            [rightBtn3 setImage:(UIImage *)rightButtonItem forState:UIControlStateNormal];
            [rightBtn3 addTarget:self action:@selector(right3ButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            right3 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn3];
            
        }else{
            right3 = nil;
        }
        NSMutableArray *rightBtnArray = [NSMutableArray array];
        if (right1) [rightBtnArray addObject:right1];
        if (right2) [rightBtnArray addObject:right2];
        if (right3) [rightBtnArray addObject:right3];
        self.navigationItem.rightBarButtonItems = rightBtnArray;
    }
}

- (UIView *)viewInNaviWithTag:(NSInteger)tag
{
    if (tag == 1140) {
        
        return right2.customView;
    }else if (tag == 1150){
        
        return right3.customView;
    }
    
    return nil;
}

#pragma mark - action
- (void)leftBarButtonItemClicked:(UIBarButtonItem *)barButtonItem {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
#ifdef NAVBARMAIN
        if ([MainNavHandle Share].navController) {
            [[MainNavHandle Share].navController popViewControllerAnimated:YES];
        }
#endif
        
#ifdef TABBARMAIN
        if ([[MainHandle Share] getShowViewController] != self) {
            [(GeneralViewController *)[[MainHandle Share] getShowViewController] leftBarButtonItemClicked:barButtonItem];
        }
#endif
        
    }
}
- (void)left2ButtonItemClicked:(UIButton *)barButtonItem {}        // 由子类重写.
- (void)left3ButtonItemClicked:(UIButton *)barButtonItem {}

- (void)rightBarButtonItemClicked:(UIBarButtonItem *)barButtonItem {
    // 由子类重写.
    if ([[MainHandle Share] getShowViewController] != self) {
        [(GeneralViewController *)[[MainHandle Share] getShowViewController] rightBarButtonItemClicked:barButtonItem];
    }
}
- (void)right2ButtonItemClicked:(UIButton *)barButtonItem {}        // 由子类重写.
- (void)right3ButtonItemClicked:(UIButton *)barButtonItem {}        // 由子类重写.

- (void)receiveMessage:(id)msg {}

// 刷新子类用，在此不做处理
- (void)refreshController{
}

// 对出栈进行回调用
- (void)viewControllerDidPopFromNavigationController {}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 方式1.匹配keypath
    if ([keyPath isEqualToString:@"frame"]) {
        _needReload = YES;
        [self viewWillAppear:NO];
    }
}

@end
