//
//  GeneralUIUse.h
//  ZYYObjcLib
//
//  Created by zyyuann on 2017/4/19.
//  Copyright © 2017年 ZYY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#define ThumbnailMode           @"_140"

typedef void (^SelectEndBlock)(NSError *);        // 图片数组 和 视频数组     NSArray<UIImage *> * ,NSArray<NSString *> *
typedef void (^CancleBlock)(void);

@interface GeneralPhotoSelect : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<UIImage *> *selectPhotos;            // 存在【nsnull】的对象，表示对应图片解析失败
@property (nonatomic, strong, readonly) NSMutableArray<NSString *> *selectVideoPaths;      // 视频只能存路径

@property (nonatomic, copy) SelectEndBlock handle;

@property (nonatomic, copy) CancleBlock cancleBlock;            // 取消选择回调

@property (weak, nonatomic) UIViewController *rootController;           // 用于弹出图片选择器

@property (nonatomic, strong) UIImage *leftImage;

@property (nonatomic, strong) UIImage *closeImage;      // 删除选中图标

@property (nonatomic, strong) UIImage *selectInImage;      // 选中图标
@property (nonatomic, strong) UIImage *selectImage;      // 未选中图标

@property (nonatomic, strong) UIImage *videoBottomImage;      // 视频底部背景
@property (nonatomic, strong) UIImage *videoImage;      // 视频图标
@property (nonatomic, strong) UIImage *takePhotoImage;       // 拍照item

@property (nonatomic, strong) UIImage *btnRotateImage;       // 编辑照片
@property (nonatomic, strong) UIImage *revokeImage;       // 编辑照片
@property (nonatomic, strong) UIImage *clipImage;       // 编辑照片
@property (nonatomic, strong) UIImage *rotateImage;       // 编辑照片
@property (nonatomic, strong) UIImage *filterImage;       // 编辑照片
@property (nonatomic, strong) UIImage *drawImage;       // 编辑照片

@property (nonatomic, strong) UIImage *videoLeftImage;       // 编辑视频
@property (nonatomic, strong) UIImage *videoRightImage;       // 编辑视频
@property (nonatomic, strong) UIImage *playVideoImage;          // 编辑视频

@property (nonatomic, strong) UIImage *photoArrowDown;          // 拍照logo
@property (nonatomic, strong) UIImage *photoFocus;          // 拍照logo
@property (nonatomic, strong) UIImage *photoRetake;          // 拍照logo
@property (nonatomic, strong) UIImage *photoTakeok;          // 拍照logo
@property (nonatomic, strong) UIImage *photoToggleCamera;          // 拍照logo

/**
 默认初始化一个小图，缩略图

 @param page 最大张数
 @return 结果
 */
- (instancetype)initImageMaxImagePage:(NSUInteger)page VideoPage:(NSUInteger)v_page;

/**
 是否进入选择模式
 */
- (void)openTouchSelect;

@end
