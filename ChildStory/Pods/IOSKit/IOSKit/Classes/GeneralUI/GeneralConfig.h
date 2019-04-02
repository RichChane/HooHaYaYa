//
//  GeneralConfig.h
//  Expecta
//
//  Created by zhang yyuan on 2018/2/28.

//  用于 app 启动是存储 每个app的 信息 用于配置项目的差异
//  一定要在app启动的时候配置好

#import <Foundation/Foundation.h>
#import <KPFoundation/KPFoundation.h>

#define GC          [GeneralConfig Config]
#define GCReload         [[GeneralConfig Config] reloadConfig]

#define SizeHeight_Iphone4           480
#define SizeHeight_Iphone5           568
#define SizeHeight_Iphone6           667
#define SizeHeight_IphonePlus           736
#define SizeHeight_IphoneX           812
#define SizeWidth_IPad_Air_Pro_9_7           768
#define SizeWidth_IPadPro_10_5           834
#define SizeWidth_IPadPro_12_9         1024

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IsIphone (GC.deviceType == GeneralDeviceTypeIphone || GC.deviceType == GeneralDeviceTypeIphoneX)

#define ASIZE(t_size)       floorf((!IsIphone?t_size:([UIScreen mainScreen].bounds.size.width / 375.0 * (t_size))))

//#define AS6(t_size)   (!IsIphone?t_size:([UIScreen mainScreen].bounds.size.width / 375.0 * (t_size)))
//#define ASPad(t_size)   (t_size)
//#define AS5(t_size)   ([UIScreen mainScreen].bounds.size.width / 360.0 * (t_size))
//#define AS6(t_size)   ([UIScreen mainScreen].bounds.size.width / 375.0 * (t_size))
//#define AS6P(t_size)   ([UIScreen mainScreen].bounds.size.width / 414.0 * (t_size))

#define AS6Frame(x,y,width,height) (!IsIphone?CGRectMake(x,y,width,height):CGRectMake(ASIZE(x),ASIZE(y),ASIZE(width),ASIZE(height)))
#define AS6Size(width,height) (!IsIphone?CGSizeMake(width,height):CGSizeMake(ASIZE(width),ASIZE(height)))
#define AS6Point(x,y) (!IsIphone?CGPointMake(x,y):CGPointMake(ASIZE(x),ASIZE(y)))

#define FontSize(x) [UIFont systemFontOfSize:ASIZE(x)]
#define ImageName(name)     [UIImage imageNamed:name]

#define OnePX 1.0f/[UIScreen mainScreen].scale

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" // 用于字符筛选

// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

typedef NS_ENUM (NSInteger,GeneralDeviceType)  {
    GeneralDeviceTypeFree = 0,
    
    GeneralDeviceTypeIphone = 1,              // iphone 设备
    GeneralDeviceTypeIphoneX ,              // iphone X 设备
    
    GeneralDeviceTypeIPad ,              // IPad 设备
};

@interface GeneralConfig : NSObject

+ (GeneralConfig *)Config;

- (void)initConfig:(NSDictionary *)dic;

- (void)reloadConfig;

// color 通用颜色
@property(strong, nonatomic) UIColor *BG;           // 默认背景色
@property(strong, nonatomic) UIColor *LINE;         // 线条默认颜色
@property(strong, nonatomic) UIColor *MC;         // 主色调
@property(strong, nonatomic) UIColor *CWhite;         // 白色
@property(strong, nonatomic) UIColor *CBlack;         // 黑色

@property CGFloat FS;       // 主字体

// fontName 使用字体
@property(strong, nonatomic) NSString *PF1;         // 中文
@property(strong, nonatomic) NSString *PF2;         // 英文数字

@property(strong, nonatomic) UIImage *qrCodeMidImage;         // 二维码中间图片

// 用于iPad上tableView的圆角
@property CGFloat cornerRadius;


// barSize  导航栏高度
@property CGFloat tabBarHeight;         // 底部导航高度
@property CGFloat tabBarOriginalHeight;        // 底部导航偏移高度
@property CGFloat tabBarSide;        // 侧边栏

// nav
@property CGFloat navBarHeight;        // 顶部导航高度
@property BOOL unLine;            // 是否需要默认线段

// top
@property (readonly) CGFloat topBarNowHeight;        // 顶部状态栏实际高度
@property (readonly) CGFloat topBarNormalHeight;        // 顶部状态栏正常高度

@property (readonly) NSInteger deviceSize;              // 设备尺寸
@property (readonly) GeneralDeviceType deviceType;      // 设备类型


@end

#import <IOSKit/GeneralConfig+Extend.h>
