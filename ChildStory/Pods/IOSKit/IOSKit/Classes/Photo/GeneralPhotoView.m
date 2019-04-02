//
//  GeneralUIUse.m
//  ZYYObjcLib
//
//  Created by zyyuann on 2017/4/19.
//  Copyright © 2017年 ZYY. All rights reserved.
//

#import <IOSKit/GeneralPhotoView.h>

#import <IOSKit/BigImgViewController.h>

#import <SDWebImage/UIButton+WebCache.h>

#import <KPFoundation/KPFoundation.h>

#import <ZLDefine.h>
#import <ZLPhotoActionSheet.h>
#import <ZLPhotoModel.h>

#import <IOSKit/ZLPhotoConfiguration.h>
#import <IOSKit/GeneralConfig.h>

@interface GeneralPhotoView () {
    
    ZLPhotoConfiguration *configuration;
    
    NSArray *imageThumbList;            // 只提过缩略图的链接，因为在加载原图时可以去掉
    
    NSString *videoUrl;
    
    NSInteger indexSelect;
    
    NSMutableArray <NSString *>*delImageList;
    BOOL isDelVideo;
    
    // 左下角的播放按钮
    UIImageView * playImageView;
}

@end

@implementation GeneralPhotoView

+ (UIImage *)getImageFromURL:(NSString *)fileURL {
    if ([fileURL hasPrefix:@"http"]) {
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
        if (data) {
            return [UIImage imageWithData:data];
        }
        
    } else {
        UIImage *image_ = [UIImage imageWithContentsOfFile:fileURL];
        if (image_) {
            return image_;
        }
    }
    
    return nil;
}

- (instancetype)initImageWithFrame:(CGRect)frame OpenTouchController:(UIViewController *)rc {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode =  UIViewContentModeScaleAspectFill;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        
        //        [_imageView setContentMode:UIViewContentModeScaleToFill];
        _isEditTool = NO;
        
        _longShareBlock = nil;
        
        
        indexSelect = 0;
        
        isDelVideo = NO;
        delImageList = [[NSMutableArray alloc] init];
        
        playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - ASIZE(24), ASIZE(24), ASIZE(24))];
        playImageView.backgroundColor = [UIColor clearColor];
        playImageView.hidden = NO;
        [self addSubview:playImageView];
        
        if (rc) {
            _rootController = rc;
            [self addTarget:self action:@selector(touchShow) forControlEvents:(UIControlEventTouchUpInside)];
        }
    }
    return self;
}

- (void)reloadURLList:(NSArray *)urlList ShowIndex:(NSInteger)index_ Video:(NSString *)video PlaceholderImage:(UIImage *)image_pl PlaceholderVideo:(UIImage *)video_pl {
    
    [self reloadURLList:urlList ShowIndex:index_ Video:video PlaceholderImage:image_pl PlaceholderVideo:video_pl IsShowPlayImage:NO];
}

- (void)reloadURLList:(NSArray *)urlList ShowIndex:(NSInteger)index_ Video:(NSString *)video PlaceholderImage:(UIImage *)image_pl PlaceholderVideo:(UIImage *)video_pl IsShowPlayImage:(BOOL)isShowPlayImage{
    
    if (urlList && [urlList count]) {
        imageThumbList = [urlList copy];
    } else {
        imageThumbList = nil;
    }
    videoUrl = video;
    
    indexSelect = index_ + 1;
    
    _showURL = nil;
    
    // 存在图片
    if (imageThumbList && [imageThumbList count] > index_ && index_ >= 0) {
        _showURL = imageThumbList[index_];
        if ([_showURL hasPrefix:@"http"]) {
            @OSWeak(self);
            [self sd_setImageWithURL:[NSURL URLWithString:_showURL] forState:(UIControlStateNormal) placeholderImage:image_pl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                @OSStrong(self);
                
                [self endLoad];
            }];
            
        } else {
            UIImage *image_ = [UIImage imageWithContentsOfFile:_showURL];
            if (image_) {
                [self setImage:image_ forState:(UIControlStateNormal)];
                
                [self endLoad];
            }
        }
    }else {
        // 不存在图片
        [self setImage:image_pl forState:(UIControlStateNormal)];
    }
    
    // 存在视频
    if (videoUrl && [videoUrl length]) {
        playImageView.image = video_pl;
        playImageView.hidden = !isShowPlayImage;
    }else {
        playImageView.hidden = YES;
    }
}

- (void)addURLVideo:(NSString *)video ImageList:(NSArray *)urlList Placeholder:(UIImage *)image {
    if (urlList && [urlList count]) {
        imageThumbList = [urlList copy];
    } else {
        imageThumbList = nil;
    }
    
    self.backgroundColor = GC.CBlack;
    indexSelect = 10000;
    videoUrl = video;
    if (image) {
        [self setImage:image forState:(UIControlStateNormal)];
    }
}

- (void)endLoad {
    if (self.loadEnd) {
        CGRect iFrame = self.frame;
        iFrame.size.height = iFrame.size.width * self.imageView.image.size.height / self.imageView.image.size.width;
        [self setFrame:iFrame];
        self.loadEnd();
    }
}

- (void)configPhoto {
    if (!configuration) {
        configuration = [ZLPhotoConfiguration defaultPhotoConfiguration];
        
        //以下参数为自定义参数，均可不设置，有默认值
        //    configuration.sortAscending = self.sortSegment.selectedSegmentIndex==0;
        configuration.allowSelectImage = NO;
        //configuration.allowSelectGif = NO;
        configuration.allowSelectVideo = NO;
        configuration.allowEditVideo = NO;
        configuration.allowSelectLivePhoto = YES;
        configuration.allowForceTouch = NO;
        configuration.allowEditImage = NO;
        configuration.allowSlideSelect = NO;
        configuration.allowMixSelect = NO;
        configuration.allowDragSelect = YES;
        configuration.allowSelectOriginal = NO;     // 不要选择原图
        //设置相册内部显示拍照按钮
        configuration.allowTakePhotoInLibrary = NO;
        //设置在内部拍照按钮上实时显示相机俘获画面
        configuration.showCaptureImageOnTakePhotoBtn = NO;
        //设置照片最大预览数
        configuration.maxPreviewCount = 10;
        //设置照片最大选择数
        configuration.maxSelectCount = 10;
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
        
        //是否允许框架解析图片
        configuration.shouldAnialysisAsset = NO;
        //框架语言
        configuration.languageType = ZLLanguageSystem;
        
        configuration.playVideoImage = _playVideoImage;
        configuration.leftImage = _leftImage;
        configuration.delImage = _delImage;
        configuration.rightImage = _rightImage;
        
        if (_isEditTool) {
            configuration.navBarColor = GC.CWhite;
            configuration.bottomViewBgColor = GC.CWhite;
            configuration.allowDelEdit = YES;
            
        }else if(_isBigImageView){
            configuration.navBarColor = GC.CWhite;
            configuration.bottomViewBgColor = GC.CWhite;
        }else {
            configuration.navBarColor = [UIColor clearColor];
            configuration.bottomViewBgColor = [UIColor clearColor];
            
        }
    }
}

#pragma mark 事件处理
- (void)touchShow {
    if (_rootController) {
        [self configPhoto];
        
        //转换为对应类型的model对象
        NSMutableArray<ZLPhotoModel *> *models = [NSMutableArray arrayWithCapacity:6];
        
        if (videoUrl) {
            ZLPhotoModel *model = [[ZLPhotoModel alloc] init];
            model.type = ZLAssetMediaTypeNetVideo;
            if ([videoUrl hasPrefix:@"http"]) {
                model.url = [NSURL URLWithString:videoUrl];
                
            } else {
                model.url = [NSURL fileURLWithPath:videoUrl];
            }
            
            model.selected = NO;
            [models addObject:model];
        }
        
        for (NSString *iUrl in imageThumbList) {
            ZLPhotoModel *model = [[ZLPhotoModel alloc] init];
            model.type = ZLAssetMediaTypeNetImage;
            if ([iUrl hasPrefix:@"http"]) {
                model.url = [NSURL URLWithString:[iUrl stringByReplacingOccurrencesOfString:ThumbnailMode withString:@""]];
                
            } else {
                model.url = [NSURL fileURLWithPath:iUrl];
                
            }
            
            model.selected = NO;
            [models addObject:model];
        }
        
        if (![models count]) {
            return;
        }
        
        BigImgViewController *svc = [[BigImgViewController alloc] init];
        svc.unNeedNav = YES;
        svc.arrSelPhotos = nil;
        svc.models = models;
        svc.configuration = configuration;
        
        svc.hideToolBar = !_isEditTool;
        
        svc.titleStr = self.titleStr;
        svc.isBigImageView = self.isBigImageView;
        svc.fromVType = self.fromVType;
        
        if (indexSelect == 10000) {
            svc.selectIndex = 0;
        } else {
            if (!videoUrl) {
                indexSelect--;
            }
            if ([models count] > indexSelect) {
                svc.selectIndex = indexSelect;
            }
        }
        
        @OSWeak(self);
        __weak typeof(svc) weakSvc = svc;
        [svc setCancelPreviewBlock:^{
            @OSStrong(self);
            if (self.handle) {
                self.handle([delImageList copy] ,isDelVideo);
            }
            
            __strong typeof(weakSvc) strongSvc = weakSvc;
            [strongSvc dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [svc setDelPreviewBlock:^(ZLPhotoModel *delModel) {
            
            if (delModel.type == ZLAssetMediaTypeNetVideo) {
                isDelVideo = YES;
            } else if (delModel.type == ZLAssetMediaTypeNetImage) {
                [delImageList addObject:delModel.url.absoluteString];
            }
            
        }];
        
        svc.longShareBlock = _longShareBlock;
        svc.rightButtonTagIndex = _rightButtonTagIndex;
        
        [_rootController showDetailViewController:svc sender:nil];
    }
}

/*
 /// 根据url获取视频第一帧图片
 - (void)videoImageWithUrl:(NSString *)urlStr {
 
 
 NSURL *url = nil;
 if ([urlStr hasPrefix:@"http"]) {
 url = [NSURL URLWithString:urlStr];
 [self videoImageWithvideoURL:url atTime:0];
 
 } else {
 if (![urlStr hasSuffix:@".mp4"]) {
 urlStr = [urlStr stringByAppendingString:@".mp4"];
 }
 url = [NSURL fileURLWithPath:urlStr];
 [self videoImageLoaclURL:url];
 }
 
 }
 // 本地url
 - (void)videoImageLoaclURL:(NSURL *)videoURL{
 
 //先从缓存中找是否有图片
 SDImageCache *cache =  [SDImageCache sharedImageCache];
 UIImage *memoryImage =  [cache imageFromMemoryCacheForKey:videoURL.absoluteString];
 if (memoryImage) {
 [self setImage:memoryImage forState:UIControlStateNormal];
 return;
 }else{
 UIImage *diskImage =  [cache imageFromDiskCacheForKey:videoURL.absoluteString];
 if (diskImage) {
 [self setImage:diskImage forState:UIControlStateNormal];
 return;
 }
 }
 
 // 获取第一帧图片
 MPMoviePlayerController * iosMPMovie = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
 UIImage *img = [iosMPMovie thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
 if (img) {
 [cache storeImage:img forKey:videoURL.absoluteString toDisk:YES completion:nil];
 [self setImage:img forState:UIControlStateNormal];
 }
 }
 
 // 网络url
 - (void)videoImageWithvideoURL:(NSURL *)videoURL atTime:(NSTimeInterval)time {
 
 NSString * flidUrl = @"";
 
 NSString *fileName = videoURL.lastPathComponent;
 if (![fileName hasSuffix:@".mp4"]) {
 fileName = [fileName stringByAppendingString:@".mp4"];
 }
 
 // 判断本地是否有视频文件
 if ([FileUseOther OperatingIsInFile:fileName]) {
 
 flidUrl = [FileUseOther OperatingRouteFile:fileName];
 [self videoImageLoaclURL:[NSURL fileURLWithPath:flidUrl]];
 }else {
 // 先把数据下载到本地
 WeakSelf;
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 // 耗时操作放在这里
 
 NSData *data = [NSData dataWithContentsOfURL:videoURL];
 if (data) {
 __strong typeof(weakSelf) strongSelf = weakSelf;
 [FileUseOther WriteData:data FileName:fileName];
 // 回到主线程进行UI操作
 dispatch_async(dispatch_get_main_queue(), ^{
 [strongSelf videoImageLoaclURL:[NSURL fileURLWithPath:[FileUseOther OperatingRouteFile:fileName]]];
 });
 }
 });
 }
 }
 */

@end

