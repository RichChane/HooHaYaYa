//
//  ZLEditViewController.m
//  ZLPhotoBrowser
//
//  Created by long on 2017/6/23.
//  Copyright © 2017年 long. All rights reserved.
//

#import "ZLEditViewController.h"
#import "ZLPhotoModel.h"
#import "ZLDefine.h"
#import "ZLPhotoManager.h"
#import "ToastUtils.h"
#import "ZLProgressHUD.h"

#import "ZLImageEditTool.h"

#import "PhotoNavigationController.h"
#import "ZLPhotoConfiguration.h"

//!!!!: edit vc
@interface ZLEditViewController ()
{
    UIActivityIndicatorView *_indicator;
    
    ZLImageEditTool *_editTool;
}

@end

@implementation ZLEditViewController

- (void)dealloc
{
    //    NSLog(@"---- %s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavBar.hidden = YES;
    [self setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _editTool.frame = self.view.bounds;
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self loadEditTool];
    [self loadImage];
}

- (void)loadImage
{
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.center = self.view.center;
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _indicator.hidesWhenStopped = YES;
    [self.view addSubview:_indicator];
    
    CGFloat scale = 3;
    CGFloat width = MIN(kViewWidth, kMaxImageWidth);
    CGSize size = CGSizeMake(width*scale, width*scale*self.model.asset.pixelHeight/self.model.asset.pixelWidth);
    
    [_indicator startAnimating];
    zl_weakify(self);
    [ZLPhotoManager requestImageForAsset:self.model.asset size:size completion:^(UIImage *image, NSDictionary *info) {
        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            zl_strongify(weakSelf);
            [strongSelf->_indicator stopAnimating];
            strongSelf->_editTool.editImage = image;
            
            if (self.isFixedRatio) {
                _editTool.isFixedRatio = self.isFixedRatio;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_editTool clipBtn_click];
                });
            }
        }
    }];
}

- (void)loadEditTool
{
    ZLImageEditType editType = nil;
    if (self.isFixedRatio) {
        editType = ZLImageEditTypeClip;
    }else {
        editType = ZLImageEditTypeClip | ZLImageEditTypeRotate | ZLImageEditTypeFilter;
    }
    _editTool = [[ZLImageEditTool alloc] initWithEditType:editType image:_oriImage configuration:[(PhotoNavigationController *)self.navigationController getConfiguration]];
    zl_weakify(self);
    _editTool.cancelEditBlock = ^{
        zl_strongify(weakSelf);
        
        UIViewController *vc = [strongSelf.navigationController popViewControllerAnimated:NO];
        if (!vc) {
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
    };
    _editTool.doneEditBlock = ^(UIImage *image) {
        zl_strongify(weakSelf);
        [strongSelf saveImage:image];
    };
    [self.view addSubview:_editTool];
}

- (void)saveImage:(UIImage *)image
{
    //确定裁剪，返回
    ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
    [hud show];
    
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    ZLPhotoConfiguration *configuration = [nav getConfiguration];
    
    if (configuration.saveNewImageAfterEdit) {
        __weak typeof(nav) weakNav = nav;
        [ZLPhotoManager saveImageToAblum:image completion:^(BOOL suc, PHAsset *asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];
                if (suc) {
                    __strong typeof(weakNav) strongNav = weakNav;
                    if (strongNav.callSelectClipImageBlock) {
                        strongNav.callSelectClipImageBlock(image, asset);
                    }
                } else {
                    ShowToastLong(@"编辑保存失败");
                }
            });
        }];
    } else {
        [hud hide];
        if (image) {
            if (nav.callSelectClipImageBlock) {
                nav.callSelectClipImageBlock(image, self.model.asset);
            }
        } else {
            ShowToastLong(@"无保存图片权限");
        }
    }
}

@end

