//
//  GeneralPhotoSingleSelect.h
//  Expecta
//
//  Created by lkr on 2018/8/22.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PhotoSingleSelectCameraAndPhotoAlbum = 0,  // 打开相机和相册
    PhotoSingleSelectCamera,
    PhotoSingleSelectPhotoAlbum  // 只打开相册
} PhotoSingleSelectType;

typedef enum : NSUInteger {
    PhotoSelectMulti = 0,   // 多选
    PhotoSelectSingle       // 单选
} PhotoSelectType;

typedef void (^SelectSingleEndBlock)(UIImage * image);        // 图片数组 和 视频数组     NSArray<UIImage *> * ,NSArray<NSString *> *
typedef void (^CancleSingleBlock)(void);

@interface GeneralPhotoSingleSelect : NSObject

@property (nonatomic, copy) SelectSingleEndBlock handle;

@property (nonatomic, copy) CancleSingleBlock cancleBlock;            // 取消选择回调

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

@property (nonatomic, assign) BOOL allowEditImage;  // 能否编辑图片

// 图片宽度 图片高度 对应的比例
- (instancetype)initWithSelectType:(PhotoSingleSelectType)type ImageWidth:(NSInteger)imageWidth ImageHeight:(NSInteger)imageHeight;
/**
 是否进入选择模式
 */
- (void)openTouchSelect;
@end


