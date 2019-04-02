//
//  GeneralUIUse.m
//  ZYYObjcLib
//
//  Created by zyyuann on 2017/4/19.
//  Copyright © 2017年 ZYY. All rights reserved.
//

#import <IOSKit/GeneralPhotoSelect.h>

#import <KPFoundation/KPFoundation.h>
#import <IOSKit/ZLDefine.h>

#import <IOSKit/ZLPhotoManager.h>
#import <IOSKit/PhotoNavigationController.h>

#import <IOSKit/PhotoSelectController.h>
#import <IOSKit/ZLPhotoConfiguration.h>

#import <IOSKit/PhotoMainListController.h>
#import <IOSKit/GeneralConfig.h>

@interface GeneralPhotoSelect ()<PHPhotoLibraryChangeObserver> {
    NSUInteger photoMaxPage;          // 可选中张数，默认9
    NSUInteger videoMaxPage;          // 可选中数，默认1
    
    BOOL isOriginal;
    
    ZLPhotoConfiguration *configuration;
    
    NSInteger selectMaxCount;
    
    PhotoNavigationController *navigation;
}

@end

@implementation GeneralPhotoSelect

- (instancetype)initImageMaxImagePage:(NSUInteger)page VideoPage:(NSUInteger)v_page {
    photoMaxPage = page;
    videoMaxPage = v_page;
    _selectPhotos = [NSMutableArray arrayWithCapacity:page];
    _selectVideoPaths = [NSMutableArray arrayWithCapacity:v_page];
    
    selectMaxCount = 0;
    
    self = [super init];
    if (self) {
        
        if (![ZLPhotoManager havePhotoLibraryAuthority]) {
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
        configuration.allowEditImage = YES;
        configuration.allowSlideSelect = NO;
        configuration.allowMixSelect = YES;
        configuration.allowDragSelect = YES;
        configuration.allowSelectOriginal = NO;     // 不要选择原图
        //设置相册内部显示拍照按钮
        configuration.allowTakePhotoInLibrary = YES;
        //设置在内部拍照按钮上实时显示相机俘获画面
        configuration.showCaptureImageOnTakePhotoBtn = YES;
        //设置照片最大预览数
        configuration.maxPreviewCount = 200;
        //设置照片最大选择数
        configuration.maxSelectCount = photoMaxPage;
        configuration.showSelectBtn = YES;
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
        //    configuration.clipRatios = @[GetClipRatio(7, 1)];
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
        
        if (videoMaxPage > 0) {
            configuration.allowSelectVideo = YES;
            configuration.allowEditVideo = YES;
        } else {
            configuration.allowSelectVideo = NO;
            configuration.allowEditVideo = NO;
        }
    }
}

- (void)openTouchSelect {
    
    
    configuration.bottomHeight = 80;
    configuration.bottomImageSize = 55;
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
    
    [self reloadLibrary];
}

#pragma mark UI
- (void)reloadLibrary {
    if (_rootController) {
        PhotoMainListController *photoBrowser = [[PhotoMainListController alloc] init];
        
        navigation = [[PhotoNavigationController alloc] initConfiguration:configuration Root:photoBrowser];
        __weak typeof(PhotoNavigationController *) weakNav = navigation;
        [navigation setCallSelectImageBlock:^{
            
            [self requestSelPhotos:weakNav data:weakNav.arrSelectedModels hideAfterCallBack:YES];
        }];
        
        [navigation setCallSelectClipImageBlock:^(UIImage *image, PHAsset *asset){
            
            ZLPhotoModel *model = [ZLPhotoModel modelWithAsset:asset type:ZLAssetMediaTypeImage duration:nil];
            
            //            if (model) {
            //                [weakNav.arrSelectedModels addObject:model];
            //            }
            
            for (id vc in weakNav.viewControllers) {
                if ([vc isKindOfClass:[PhotoSelectController class]]) {
                    [((PhotoSelectController *)vc) reloadCollectionViewFrowOutSideWithAddModel:model];
                    [weakNav popToViewController:vc animated:YES];
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
        [navigation pushViewController:tvc animated:YES];
        [_rootController showDetailViewController:navigation sender:nil];
    }
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
    
    selectMaxCount = [data count];
    
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
                        [self finishHandle:image];
                        
                        if (selectMaxCount == ([_selectPhotos count] + [_selectVideoPaths count])) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [hud hide];
                                if (self.handle) {
                                    self.handle(nil);
                                }
                                if (hide) {
                                    [vc dismissViewControllerAnimated:YES completion:nil];
                                }
                            });
                        }
                    }
                }];
                
            } else if (model.type == ZLAssetMediaTypeVideo) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ZLPhotoManager exportVideoForAsset:model.asset type:(ZLExportVideoTypeMp4) complete:^(NSString *exportFilePath, NSError *error) {
                        [self finishHandle:exportFilePath];
                        
                        if (selectMaxCount == ([_selectPhotos count] + [_selectVideoPaths count])) {
                            
                            [hud hide];
                            if (self.handle) {
                                self.handle(nil);
                            }
                            if (hide) {
                                [vc dismissViewControllerAnimated:YES completion:nil];
                            }
                        }
                    }];
                });
            }
        }
    });
}
- (void)finishHandle:(id)value {
    if (value && [value isKindOfClass:[UIImage class]]) {
        [_selectPhotos addObject:[ZLPhotoManager scaleImage:value original:YES]];
        
    } else if (value && [value isKindOfClass:[NSString class]]) {
        [_selectVideoPaths addObject:value];
        
    } else {
        [_selectPhotos addObject:[NSNull null]];
    }
    
}

@end
