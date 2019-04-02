//
//  BigImgViewController.h
//  Expecta
//
//  Created by zhang yyuan on 2018/5/7.
//  图片 预览

#import <IOSKit/GeneralViewController.h>
#import <Photos/Photos.h>

#import <IOSKit/ZLPhotoConfiguration.h>
#import <IOSKit/IOSKit.h>

@class ZLPhotoModel;

@interface BigImgViewController : GeneralViewController

@property (nonatomic, assign) ZLPhotoConfiguration *configuration;

@property (nonatomic, strong) NSArray<ZLPhotoModel *> *models;

@property (nonatomic, assign) NSInteger selectIndex; //选中的图片下标

//点击选择后的图片预览数组，预览相册图片时为 UIImage，预览网络图片时候为UIImage/NSUrl
@property (nonatomic, strong) NSMutableArray *arrSelPhotos;

/**预览 网络/本地 图片时候是否 隐藏底部工具栏和导航右上角按钮*/
@property (nonatomic, assign) BOOL hideToolBar;

//预览相册图片回调
@property (nonatomic, copy) void (^previewSelectedImageBlock)(NSArray<UIImage *> *arrP, NSArray<PHAsset *> *arrA);

//预览网络图片回调
@property (nonatomic, copy) void (^previewNetImageBlock)(NSArray *photos);

//预览 相册/网络 图片时候，点击返回回调
@property (nonatomic, copy) void (^delPreviewBlock)(ZLPhotoModel *delModel);

//预览 相册/网络 图片时候，点击返回回调
@property (nonatomic, copy) void (^cancelPreviewBlock)(void);

//预览 相册/网络 图片的时候，长按返回回调
@property (nonatomic, copy) void (^longShareBlock)(UIImage *img, NSInteger sel);

// 操作结束返回 相册/网络 图片时候，点击返回回调
@property (nonatomic, copy) void (^finishBackBlock)(NSArray<ZLPhotoModel *> *selectedModels, BOOL isOriginal);

// 区分单选还是多选  默认多选
@property (nonatomic, assign) PhotoSelectType selectPhotoType;
// 大图模式下 右上角选择index
@property (nonatomic, copy) void (^rightButtonTagIndex)(NSInteger index);


///区分界面
@property (nonatomic, assign)FromVCType fromVType;
@property (nonatomic, copy) NSString * titleStr;   // 标题title
@property (nonatomic, assign) BOOL isBigImageView;  // 区分删除和之前的显示功能  默认为NO

@end

