//
//  GeneralPhotoSingleSelect.m
//  Expecta
//
//  Created by lkr on 2018/8/22.
//

#import "GeneralPhotoSingleSelect.h"

#import <IOSKit/ZLDefine.h>

#import <IOSKit/ZLPhotoManager.h>
#import <IOSKit/PhotoNavigationController.h>

#import <IOSKit/PhotoSelectController.h>
#import <IOSKit/ZLPhotoConfiguration.h>

#import <IOSKit/PhotoMainListController.h>
#import <IOSKit/GeneralConfig.h>

#import "ZLDefine.h"
#import "ZLCustomCamera.h"
#import "PhotoNavigationController.h"
#import "ZLPhotoConfiguration.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <IOSKit/IOSKit.h>
#import <KPFoundation/KPFoundation.h>

#import <IOSKit/ZLEditViewController.h>

@interface GeneralPhotoSingleSelect()
{
    PhotoSingleSelectType selectType;
    
    ZLPhotoConfiguration *configuration;
    
    NSInteger selectMaxCount;
    
    NSInteger imgWidth;
    NSInteger imgHeight;
    
    PhotoNavigationController *navigation;
}


@end

@implementation GeneralPhotoSingleSelect

- (instancetype)initWithSelectType:(PhotoSingleSelectType)type ImageWidth:(NSInteger)imageWidth ImageHeight:(NSInteger)imageHeight {
    
    selectType = type;
    imgWidth = imageWidth;
    imgHeight = imageHeight;
    
    if(self = [super init]) {
        
        if ((type == PhotoSingleSelectPhotoAlbum || type == PhotoSingleSelectCameraAndPhotoAlbum) && ![ZLPhotoManager havePhotoLibraryAuthority]) {
            //注册实施监听相册变化
            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        }
        
        [self configPhoto];
        
    }
    
    return self;
}

- (void)configPhoto {
    if (!configuration) {
        configuration = [ZLPhotoConfiguration defaultPhotoConfiguration];
        
        //以下参数为自定义参数，均可不设置，有默认值
        configuration.sortAscending = NO;
        configuration.allowSelectImage = YES;
        //configuration.allowSelectGif = NO;
        configuration.allowSelectLivePhoto = YES;
        configuration.allowForceTouch = NO;
        configuration.allowSlideSelect = NO;
        configuration.allowMixSelect = YES;
        configuration.allowDragSelect = YES;
        configuration.allowSelectOriginal = NO;     // 不要选择原图
        if(selectType == PhotoSingleSelectCameraAndPhotoAlbum) {
            //设置相册内部显示拍照按钮
            configuration.allowTakePhotoInLibrary = YES;
            //设置在内部拍照按钮上实时显示相机俘获画面
            configuration.showCaptureImageOnTakePhotoBtn = YES;
        }else {
            configuration.allowTakePhotoInLibrary = NO;
            configuration.showCaptureImageOnTakePhotoBtn = NO;
        }
        
        //设置照片最大预览数
        configuration.maxPreviewCount = 200;
        //设置照片最大选择数
        configuration.maxSelectCount = 1;
        configuration.showSelectBtn = NO;
        //设置允许选择的视频最大时长
        configuration.maxVideoDuration = 10;
        configuration.maxEditVideoTime = 10;
        //设置照片cell弧度
        configuration.cellCornerRadio = 2;
        //单选模式是否显示选择按钮
        //    configuration.showSelectBtn = YES;
        //是否在选择图片后直接进入编辑界面
        configuration.editAfterSelectThumbnailImage = NO;
        //是否保存编辑后的图片
        //    configuration.saveNewImageAfterEdit = NO;
        //设置编辑比例
        if (imgWidth && imgHeight) {
            configuration.clipRatios = @[GetClipRatio(imgWidth, imgHeight)];
        }
        //是否在已选择照片上显示遮罩层
        configuration.showSelectedMask = NO;
        //颜色，状态栏样式
        configuration.navBarColor = GC.CWhite;
        configuration.bottomViewBgColor = GC.CWhite;
        
        configuration.exportVideoType = ZLExportVideoTypeMp4;
        
        //是否允许框架解析图片
        //        configuration.shouldAnialysisAsset = NO;
        //框架语言
        configuration.languageType = ZLLanguageSystem;
        
        configuration.allowSelectVideo = NO;
        configuration.allowEditVideo = NO;
    }
}

- (void)openTouchSelect {
    
    configuration.allowEditImage = _allowEditImage;
    
    configuration.bottomHeight = 0;
    configuration.bottomImageSize = 0;
    configuration.leftImage = _leftImage;
    
    configuration.closeImage = _closeImage;
    
    configuration.videoBottomImage = _videoBottomImage;
    configuration.videoImage = _videoImage;
    
    configuration.selectImage = _selectImage;
    configuration.selectInImage = _selectInImage;
    
    configuration.takePhotoImage = _takePhotoImage;
    
    configuration.btnRotateImage = _btnRotateImage;
    configuration.revokeImage = _revokeImage;
    configuration.clipImage = _clipImage;
    configuration.rotateImage = _rotateImage;
    configuration.filterImage = _filterImage;
    configuration.drawImage = _drawImage;
    
    configuration.videoLeftImage = _videoLeftImage;
    configuration.videoRightImage = _videoRightImage;
    configuration.playVideoImage = _playVideoImage;
    
    configuration.photoArrowDown = _photoArrowDown;
    configuration.photoFocus = _photoFocus;
    configuration.photoRetake = _photoRetake;
    configuration.photoTakeok = _photoTakeok;
    configuration.photoToggleCamera = _photoToggleCamera;
    
    [ZLPhotoManager setSortAscending:configuration.sortAscending];
    
    if (selectType == PhotoSingleSelectCameraAndPhotoAlbum || selectType == PhotoSingleSelectPhotoAlbum) {
        // 打开相册  或者相册中带相机
        [self reloadLibrary];
    }else {
        // 只打开相机
        [self openCameraLibrary];
    }
    
    
}

#pragma mark UI
- (void)reloadLibrary {
    
    if (_rootController) {
        PhotoMainListController *photoBrowser = [[PhotoMainListController alloc] init];
        photoBrowser.selectPhotoType = PhotoSelectSingle;
        navigation = [[PhotoNavigationController alloc] initConfiguration:configuration Root:photoBrowser];
        __weak typeof(PhotoNavigationController *) weakNav = navigation;
        [navigation setCallSelectImageBlock:^{
            
            [self requestSelPhotos:weakNav data:weakNav.arrSelectedModels hideAfterCallBack:YES];
        }];
        
        [navigation setCallSelectClipImageBlock:^(UIImage *image, PHAsset *asset){
            
            ZLPhotoModel *model = [ZLPhotoModel modelWithAsset:asset type:ZLAssetMediaTypeImage duration:nil];
            
            if (model) {
                [weakNav.arrSelectedModels addObject:model];
            }
            
            for (id vc in weakNav.viewControllers) {
                if ([vc isKindOfClass:[PhotoSelectController class]]) {
                    [weakNav popToViewController:vc animated:NO];
                    
                    UIImage * tempImage = [ZLPhotoManager scaleImage:image original:YES];
                    if (self.handle) {
                        self.handle(tempImage);
                    }
                    
                    [((PhotoSelectController *)vc) rightBarButtonItemClicked:nil];
                    
                    break;
                }
            }
            
        }];
        
        [navigation setCallSelectVideoBlock:^(id model) {
            
            if (model && [model isKindOfClass:[ZLPhotoModel class]]) {
                [weakNav.arrSelectedModels addObject:model];
            }
            
            for (id vc in weakNav.viewControllers) {
                if ([vc isKindOfClass:[PhotoSelectController class]]) {
                    [weakNav popToViewController:vc animated:YES];
                    break;
                }
            }
        }];
        
        [navigation setCancelBlock:^{
            if (self.cancleBlock) {
                self.cancleBlock();
            }
        }];
        
        [navigation.arrSelectedModels removeAllObjects];
        
        PhotoSelectController *tvc = [[PhotoSelectController alloc] init];
        tvc.selectPhotoType = PhotoSelectSingle;
        [navigation pushViewController:tvc animated:YES];
        [_rootController showDetailViewController:navigation sender:nil];
    }
}

- (void)openCameraLibrary {
    
    if (_rootController) {
        
        ZLCustomCamera *camera = [[ZLCustomCamera alloc] init];
        camera.photoArrowDown = configuration.photoArrowDown;
        camera.photoFocus = configuration.photoFocus;
        camera.photoRetake = configuration.photoRetake;
        camera.photoTakeok = configuration.photoTakeok;
        camera.photoToggleCamera = configuration.photoToggleCamera;
        
        camera.allowTakePhoto = configuration.allowSelectImage;
        camera.allowRecordVideo = configuration.allowSelectVideo && configuration.allowRecordVideo;
        camera.sessionPreset = configuration.sessionPreset;
        camera.videoType = configuration.exportVideoType;
        camera.circleProgressColor = configuration.bottomBtnsNormalTitleColor;
        camera.maxRecordDuration = configuration.maxRecordDuration;
        
        
        navigation = [[PhotoNavigationController alloc] initConfiguration:configuration Root:camera];
        __weak typeof(PhotoNavigationController *) weakNav = navigation;
        
        camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
            if (self.allowEditImage) {
                // 允许编辑图片
                ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
                [hud show];
                [ZLPhotoManager saveImageToAblum:image completion:^(BOOL suc, PHAsset *asset) {
                    [hud hide];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (suc) {
                            [self openImageEditView:asset];
                        } else {
                            
                        }
                    });
                }];
            }else {
                UIImage * tempImage = [ZLPhotoManager scaleImage:image original:YES];
                if (self.handle) {
                    self.handle(tempImage);
                }
            }
        };
        [_rootController showDetailViewController:navigation sender:nil];
    }
    
}

- (void)openImageEditView:(PHAsset *)asset {
    
    ZLPhotoModel *model = [ZLPhotoModel modelWithAsset:asset type:ZLAssetMediaTypeImage duration:nil];
    // 固定比例
    ZLEditViewController *vc = [[ZLEditViewController alloc] init];
    vc.model = model;
    vc.oriImage = model.image;
    vc.isFixedRatio = YES;
    vc.unGestureRecognizer = YES; //禁用返回手势
    
    navigation = [[PhotoNavigationController alloc] initConfiguration:configuration Root:vc];
    __weak typeof(PhotoNavigationController *) weakNav = navigation;
    [_rootController showDetailViewController:navigation sender:nil];
    
    [navigation setCallSelectClipImageBlock:^(UIImage *image, PHAsset *asset){
        
        UIImage * tempImage = [ZLPhotoManager scaleImage:image original:YES];
        if (self.handle) {
            self.handle(tempImage);
        }
        
        [weakNav dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
}

#pragma mark 相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        if (navigation) {
            for (id vc in navigation.viewControllers) {
                if ([vc isKindOfClass:[PhotoSelectController class]]) {
                    [((PhotoSelectController *)vc) reloadCollectionViewFrowOutSide];
                    break;
                }
            }
        }
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    });
}

#pragma mark - 请求所选择图片、回调
- (void)requestSelPhotos:(UIViewController *)vc data:(NSArray<ZLPhotoModel *> *)data hideAfterCallBack:(BOOL)hide
{
    selectMaxCount = [data count];
    if (!selectMaxCount) {
        return;
    }
    
    ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
    [hud showWithTime:30];
    hud.hudTimeOutBlock = ^{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:ML(@"提示") message:ML(@"处理时间较长，是否继续等待") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:ML(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:ML(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [hud showWithTime:30];
            
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        [vc presentViewController:alertController animated:YES completion:nil];
    };
    
    if (!configuration.shouldAnialysisAsset) {
        NSMutableArray *assets = [NSMutableArray arrayWithCapacity:data.count];
        for (ZLPhotoModel *m in data) {
            [assets addObject:m.asset];
        }
        [hud hide];
        if (self.handle) {
            self.handle(nil);
        }
        if (hide) {
            [vc dismissViewControllerAnimated:YES completion:nil];
        }
        return;
    }
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        for (int i = 0; i < data.count; i++) {
            ZLPhotoModel *model = data[i];
            if (model.type == ZLAssetMediaTypeImage || model.type == ZLAssetMediaTypeLivePhoto || model.type == ZLAssetMediaTypeGif) {
                CGFloat scale = 2;
                CGFloat width = MIN(kViewWidth, kMaxImageWidth);
                [ZLPhotoManager requestHightImageForAsset:model.asset size:CGSizeMake(width * scale, width * scale * model.asset.pixelHeight / model.asset.pixelWidth) completion:^(UIImage *image, NSDictionary *info) {
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hud hide];
                            UIImage * tempImage = [ZLPhotoManager scaleImage:image original:YES];
                            if (self.handle) {
                                self.handle(tempImage);
                            }
                            
                            if (hide) {
                                [vc dismissViewControllerAnimated:YES completion:nil];
                            }
                        });
                    }
                }];
            }
        }
    });
}

@end

