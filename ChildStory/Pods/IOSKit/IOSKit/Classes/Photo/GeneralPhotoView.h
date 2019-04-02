//
//  GeneralUIUse.h
//  ZYYObjcLib
//
//  Created by zyyuann on 2017/4/19.
//  Copyright © 2017年 ZYY. All rights reserved.
//  该类封装了两个功能，一个是删除的功能，一个是显示功能 要区分对待
//

#import <UIKit/UIKit.h>

#define ThumbnailMode           @"_140"

typedef void (^EndToBlock)(NSArray <NSString *>* delList ,BOOL delVideo);

// 从哪些界面进入到预览图  没有删除功能  主要是区分右上角的点击功能
typedef enum : NSUInteger {
    FromProductVCType = 0,   // 阅览货品图
    FromPersonAvaVCType       // 查看企业或者个人头像
} FromVCType;

@interface GeneralPhotoView : UIButton

+ (UIImage *)getImageFromURL:(NSString *)fileURL;           // 同步操作，会卡住主线程

@property (weak, nonatomic, readonly) UIViewController *rootController;           // 用于弹出图片选择器

//预览 相册/网络 图片的时候，长按返回回调
@property (nonatomic, copy) void (^longShareBlock)(UIImage *img, NSInteger sel);

// 大图模式下 右上角选择index
@property (nonatomic, copy) void (^rightButtonTagIndex)(NSInteger index);

@property (nonatomic, copy) EndToBlock handle;

@property (nonatomic, strong) UIImage *playVideoImage;          // 编辑视频

@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImage *delImage;

@property (nonatomic, readonly, strong) NSString * showURL;             // 当前展示的URL
@property BOOL isEditTool;          // 是否需要简单的编辑工具条（删除）
@property (nonatomic, copy) void (^loadEnd)(void);          // 是否根据下载的图片变更UI大小，并进行回调

///区分界面
@property (nonatomic, assign)FromVCType fromVType;
@property (nonatomic, copy) NSString * titleStr;   // 标题title
@property (nonatomic, assign) BOOL isBigImageView;  // 区分删除和之前的显示功能  默认为NO
@property (nonatomic, strong) UIImage *rightImage;  // 右上角的图标

#pragma mark 事件处理  供外部调用
- (void)touchShow;

/**
 默认初始化一个小图，缩略图
 
 @param frame 图片大小
 @param isOpen 是否开启点击进入大图处理
 @return 结果
 */
- (instancetype)initImageWithFrame:(CGRect)frame OpenTouchController:(UIViewController *)rc;

/**
 是否开启点击进入预览模式
 
 @param urlList 地址数组，支持本地、远程
 @param video 地址，支持本地、远程
 @param image_pl 图片缺省图
 @param video_pl 视频缺省图
 
 */
- (void)reloadURLList:(NSArray *)urlList ShowIndex:(NSInteger)index_ Video:(NSString *)video PlaceholderImage:(UIImage *)image_pl PlaceholderVideo:(UIImage *)video_pl;
// 有视频时是否显示播放按钮
- (void)reloadURLList:(NSArray *)urlList ShowIndex:(NSInteger)index_ Video:(NSString *)video PlaceholderImage:(UIImage *)image_pl PlaceholderVideo:(UIImage *)video_pl IsShowPlayImage:(BOOL)isShowPlayImage;
/**
 添加视频
 
 @param video 地址，支持本地、远程
 @param urlList 地址数组，支持本地、远程
 @param image 缺省图
 
 */
- (void)addURLVideo:(NSString *)video ImageList:(NSArray *)urlList Placeholder:(UIImage *)image;

@end
