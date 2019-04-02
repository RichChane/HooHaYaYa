//
//  ZLCollectionCell.m
//  多选相册照片
//
//  Created by long on 15/11/25.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ZLCollectionCell.h"
#import "ZLPhotoModel.h"
#import "ZLPhotoManager.h"
#import "ZLDefine.h"
#import "ToastUtils.h"
#import "UIButton+EnlargeTouchArea.h"


#pragma mark - ZLCollectionCell
@interface ZLCollectionCell ()

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) PHImageRequestID imageRequestID;

@end

@implementation ZLCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.btnSelect.frame = CGRectMake(GetViewWidth(self.contentView) - 30, 0, 30, 30);
    if (self.showMask) {
        self.topView.frame = self.bounds;
    }
    self.videoBottomView.frame = CGRectMake(0, GetViewHeight(self) - 20, GetViewWidth(self), 20);
    self.videoImageView.frame = CGRectMake(5, 1, 20, 20);
    self.liveImageView.frame = CGRectMake(5, -1, 15, 15);
    self.timeLabel.frame = CGRectMake(30, 0, GetViewWidth(self)-35, 20);
    [self.contentView sendSubviewToBack:self.imageView];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.bounds;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        [self.contentView bringSubviewToFront:_topView];
        [self.contentView bringSubviewToFront:self.videoBottomView];
        [self.contentView bringSubviewToFront:self.btnSelect];
    }
    return _imageView;
}

- (UIButton *)btnSelect
{
    if (!_btnSelect) {
        _btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSelect setImage:_configuration.selectImage forState:UIControlStateNormal];
        [_btnSelect setImage:_configuration.selectInImage forState:UIControlStateSelected];
        [_btnSelect addTarget:self action:@selector(btnSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnSelect];
    }
    return _btnSelect;
}

- (UIImageView *)videoBottomView
{
    if (!_videoBottomView) {
        _videoBottomView = [[UIImageView alloc] initWithImage:_configuration.videoBottomImage];
        [self.contentView addSubview:_videoBottomView];
    }
    return _videoBottomView;
}

- (UIImageView *)videoImageView
{
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithImage:_configuration.videoImage];
        [self.videoBottomView addSubview:_videoImageView];
    }
    return _videoImageView;
}

- (UIImageView *)liveImageView
{
    if (!_liveImageView) {
        _liveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -1, 20, 20)];
        _liveImageView.image = _configuration.videoImage;
        [self.videoBottomView addSubview:_liveImageView];
    }
    return _liveImageView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 1, GetViewWidth(self)-35, 12)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor whiteColor];
        [self.videoBottomView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.userInteractionEnabled = NO;
        _topView.hidden = YES;
        [self.contentView addSubview:_topView];
    }
    return _topView;
}

- (void)setModel:(ZLPhotoModel *)model
{
    _model = model;
    
    if (self.cornerRadio > .0) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.cornerRadio;
    }
    
    if (model.type == ZLAssetMediaTypeVideo) {
        self.videoBottomView.hidden = NO;
        self.videoImageView.hidden = NO;
        self.liveImageView.hidden = YES;
        self.timeLabel.text = model.duration;
    } else if (model.type == ZLAssetMediaTypeGif) {
        self.videoBottomView.hidden = !self.allSelectGif;
        self.videoImageView.hidden = YES;
        self.liveImageView.hidden = YES;
        self.timeLabel.text = @"GIF";
    } else if (model.type == ZLAssetMediaTypeLivePhoto) {
        self.videoBottomView.hidden = !self.allSelectLivePhoto;
        self.videoImageView.hidden = YES;
        self.liveImageView.hidden = NO;
        self.timeLabel.text = @"Live";
    } else {
        self.videoBottomView.hidden = YES;
    }
    
    if (self.showMask) {
        self.topView.backgroundColor = [self.maskColor colorWithAlphaComponent:.2];
        self.topView.hidden = !model.isSelected;
    }
    
    self.btnSelect.hidden = !self.showSelectBtn;
    self.btnSelect.enabled = self.showSelectBtn;
    self.btnSelect.selected = model.isSelected;
    
    if (self.showSelectBtn) {
        //扩大点击区域
        [self.btnSelect setEnlargeEdgeWithTop:0 right:0 bottom:20 left:20];
    }
    
    CGSize size;
    size.width = GetViewWidth(self) * 1.7;
    size.height = GetViewHeight(self) * 1.7;
    
    zl_weakify(self);
    if (model.asset && self.imageRequestID >= PHInvalidImageRequestID) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.identifier = model.asset.localIdentifier;
    self.imageView.image = nil;
    self.imageRequestID = [ZLPhotoManager requestImageForAsset:model.asset size:size completion:^(UIImage *image, NSDictionary *info) {
        zl_strongify(weakSelf);
        
        if ([strongSelf.identifier isEqualToString:model.asset.localIdentifier]) {
            strongSelf.imageView.image = image;
        }
        
        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            strongSelf.imageRequestID = -1;
        }
    }];
}

- (void)btnSelectClick:(UIButton *)sender {
    if (!self.btnSelect.selected) {
        [self.btnSelect.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
    }
    if (self.selectedBlock) {
        self.selectedBlock(self.btnSelect.selected);
    }
}

@end


#pragma mark - ZLTakePhotoCell
@import AVFoundation;

@interface ZLTakePhotoCell ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutPut;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ZLTakePhotoCell

- (void)dealloc
{
    if ([_session isRunning]) {
        [_session stopRunning];
    }
    _session = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGFloat width = GetViewHeight(self)/3;
        self.imageView.frame = CGRectMake(0, 0, width, width);
        self.imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:self.imageView];
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    return self;
}

- (void)restartCapture
{
    [self.session stopRunning];
    [self startCapture];
}

- (void)startCapture
{
    self.imageView.image = _configuration.takePhotoImage;
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (![UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] ||
        status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return;
    }
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.session stopRunning];
                [self.previewLayer removeFromSuperlayer];
            });
        }
    }];
    
    if (self.session && [self.session isRunning]) {
        return;
    }
    
    [self.session stopRunning];
    [self.session removeInput:self.videoInput];
    [self.session removeOutput:self.stillImageOutPut];
    self.session = nil;
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
    
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:[self backCamera] error:nil];
    self.stillImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *dicOutputSetting = [NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey];
    [self.stillImageOutPut setOutputSettings:dicOutputSetting];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutPut]) {
        [self.session addOutput:self.stillImageOutPut];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.contentView.layer setMasksToBounds:YES];
    
    self.previewLayer.frame = self.contentView.layer.bounds;
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.contentView.layer insertSublayer:self.previewLayer atIndex:0];

    [self.session startRunning];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

@end


#pragma mark - EditPhotoCell
@interface EditPhotoCell ()

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) PHImageRequestID imageRequestID;

@end

@implementation EditPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageToView.frame = self.bounds;
    self.btnDelect.frame = CGRectMake(-10, -10, 30, 30);
    self.btnDelect.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 10);
    if (self.showMask) {
        self.topView.frame = self.bounds;
    }
    self.videoBottomView.frame = CGRectMake(0, GetViewHeight(self) - 20, GetViewWidth(self), 20);
    self.videoImageView.frame = CGRectMake(5, 1, 20, 20);
    self.liveImageView.frame = CGRectMake(5, -1, 15, 15);
    [self sendSubviewToBack:self.imageToView];
}

- (UIImageView *)imageToView
{
    if (!_imageToView) {
        _imageToView = [[UIImageView alloc] init];
        _imageToView.frame = self.bounds;
        _imageToView.clipsToBounds = YES;
        _imageToView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageToView];
        
        [self bringSubviewToFront:_topView];
        [self bringSubviewToFront:self.videoBottomView];
        [self bringSubviewToFront:self.btnDelect];
    }
    return _imageToView;
}

- (UIButton *)btnDelect
{
    if (!_btnDelect) {
        _btnDelect = [[UIButton alloc] init];
        [_btnDelect setImage:_configuration.closeImage forState:UIControlStateNormal];
        [_btnDelect addTarget:self action:@selector(btnDelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnDelect];
    }
    return _btnDelect;
}

- (UIImageView *)videoBottomView
{
    if (!_videoBottomView) {
        _videoBottomView = [[UIImageView alloc] initWithImage:_configuration.videoBottomImage];
        _videoBottomView.clipsToBounds = YES;
        [self addSubview:_videoBottomView];
    }
    return _videoBottomView;
}

- (UIImageView *)videoImageView
{
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithImage:_configuration.videoImage];
        [self.videoBottomView addSubview:_videoImageView];
    }
    return _videoImageView;
}

- (UIImageView *)liveImageView
{
    if (!_liveImageView) {
        _liveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -1, 15, 15)];
        [self.videoBottomView addSubview:_liveImageView];
    }
    return _liveImageView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.userInteractionEnabled = NO;
        _topView.hidden = YES;
        [self addSubview:_topView];
    }
    return _topView;
}

- (void)setModel:(ZLPhotoModel *)model
{
    _model = model;
    
    if (self.cornerRadio > .0) {
        self.imageToView.layer.cornerRadius = self.cornerRadio;
        self.videoBottomView.layer.cornerRadius = self.cornerRadio;
    }
    
    if (model.type == ZLAssetMediaTypeVideo) {
        self.videoBottomView.hidden = NO;
        self.videoImageView.hidden = NO;
        self.liveImageView.hidden = YES;
        
    } else if (model.type == ZLAssetMediaTypeGif) {
        self.videoBottomView.hidden = !self.allSelectGif;
        self.videoImageView.hidden = YES;
        self.liveImageView.hidden = YES;
        
    } else if (model.type == ZLAssetMediaTypeLivePhoto) {
        self.videoBottomView.hidden = !self.allSelectLivePhoto;
        self.videoImageView.hidden = YES;
        self.liveImageView.hidden = NO;
        
    } else {
        self.videoBottomView.hidden = YES;
    }
    
    if (self.showMask) {
        self.topView.backgroundColor = [self.maskColor colorWithAlphaComponent:.2];
        self.topView.hidden = !model.isSelected;
    }
    
    self.btnDelect.hidden = !self.showSelectBtn;
    self.btnDelect.enabled = self.showSelectBtn;
    self.btnDelect.selected = model.isSelected;
    
    if (self.showSelectBtn) {
        //扩大点击区域
        [_btnDelect setEnlargeEdgeWithTop:0 right:0 bottom:20 left:20];
    }
    
    CGSize size;
    size.width = GetViewWidth(self) * 1.7;
    size.height = GetViewHeight(self) * 1.7;
    
    zl_weakify(self);
    if (model.asset && self.imageRequestID >= PHInvalidImageRequestID) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.identifier = model.asset.localIdentifier;
    self.imageToView.image = nil;
    self.imageRequestID = [ZLPhotoManager requestImageForAsset:model.asset size:size completion:^(UIImage *image, NSDictionary *info) {
        zl_strongify(weakSelf);
        
        if ([strongSelf.identifier isEqualToString:model.asset.localIdentifier]) {
            strongSelf.imageToView.image = image;
        }
        
        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            strongSelf.imageRequestID = -1;
        }
    }];
}

- (void)btnDelectClick:(UIButton *)sender {
    if (self.delBlock) {
        self.delBlock();
    }
}

@end

