//
//  GeneralConfig.m
//  Expecta
//
//  Created by zhang yyuan on 2018/2/28.
//

#import <IOSKit/GeneralConfig.h>

@implementation GeneralConfig

static bool isInit = NO;     // 单例初始化判断（该类不允许被继承，初始化多个）

+ (GeneralConfig *)Config
{
    static dispatch_once_t predicate;
    static GeneralConfig *checkInstance = nil;
    
    dispatch_once(&predicate, ^{
        
        isInit = YES;
        checkInstance = [[GeneralConfig alloc] init];
        isInit = NO;
    });
    return checkInstance;
}

- (instancetype)init{
    
    if (isInit) {
        self = [super init];
        if (self){  
            _BG = kUIColorFromRGB(0xF5F5F5);
            _LINE = kUIColorFromRGBAlpha(0xD4D4D4, 1);
            _MC = kUIColorFromRGB(0xFC9F06);
            
            _CWhite = [UIColor whiteColor];
            _CBlack = [UIColor blackColor];
            
            _FS = 18;
            
            _tabBarHeight = 57.0f;
            _tabBarOriginalHeight = 78.0f;
            
            _topBarNormalHeight = 20.0f;
            
            _tabBarSide = 100.0f;
            
            _navBarHeight = 44.0f;
            
            _unLine = NO;
            
            ///////////////////////////////////
            
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                _deviceSize = [UIScreen mainScreen].bounds.size.height;
                
                if (_deviceSize == SizeHeight_IphoneX) {
                    _deviceType = GeneralDeviceTypeIphoneX;
                    
                    _topBarNormalHeight = 20.0f + 24.0f;
                    _tabBarHeight = 57.0f + 68.0f / 3;
                    _tabBarOriginalHeight = 87.0f + 68.0f / 3;
                    
                } else {
                    _deviceType = GeneralDeviceTypeIphone;
                }
                
            } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                _deviceSize = [UIScreen mainScreen].bounds.size.width;
                _deviceType = GeneralDeviceTypeIPad;
            }
            
            [self reloadConfig];
            
        }
        return self;
    }
    
    NSAssert(isInit , @"GeneralConfig 类不允许被继承，初始化多个");
    
    return nil;
}

- (void)initConfig:(NSDictionary *)dic{
    
}

- (void)reloadConfig{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    if (_topBarNowHeight != rectStatus.size.height) {
        _topBarNowHeight = rectStatus.size.height;
    }
}

@end
