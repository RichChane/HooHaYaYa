//
//  BigImgViewController.m
//  Expecta
//
//  Created by zhang yyuan on 2018/5/7.
//

#import <IOSKit/BigImgViewController.h>
#import <IOSKit/IOSKit.h>
#import <KPFoundation/KPFoundation.h>

#import <ZLBigImageCell.h>
#import <ZLDefine.h>
#import <ToastUtils.h>
#import <ZLPhotoModel.h>
#import <ZLPhotoManager.h>
#import <ZLEditViewController.h>
#import <ZLEditVideoController.h>

#import "PhotoNavigationController.h"
#import "ZLPhotoConfiguration.h"

#import <BottomPopView.h>
#import <WPNormalPopView.h>

@interface BigImgViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
    
    
    //自定义导航视图
    UIView *_navView;
    UIButton *_btnBack;
    UIButton *_navRightBtn;
    UILabel *_indexLabel;
    UILabel *_titleLabel;
    
    //底部view
    UIView   *_bottomView;
    
    //编辑按钮
    UIButton *_btnEdit;
    UIButton *_delEdit;
    
    //双击的scrollView
    UIScrollView *_selectScrollView;
    NSInteger _currentPage;
    
    NSArray *_arrSelPhotosBackup;
    NSMutableArray *_arrSelAssets;
    NSArray *_arrSelAssetsBackup;
    
    BOOL _isFirstAppear;
    
    BOOL _hideNavBar;
    
    //设备旋转前的index
    NSInteger _indexBeforeRotation;
    UICollectionViewFlowLayout *_layout;
    
    NSString *_modelIdentifile;
}

@property (nonatomic, strong) UILabel *labPhotosBytes;

@end

@implementation BigImgViewController

- (void)dealloc
{
    //    NSLog(@"---- %s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _isFirstAppear = YES;
    _currentPage = self.selectIndex+1;
    _indexBeforeRotation = self.selectIndex;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setFrame:[self getShowScreen]];
    if (_isFirstAppear) {
        
        [self initNavView];
        if (_configuration.allowEditImage || _configuration.allowDelEdit) {
            // 可编辑才会创建 底部栏
            [self initBottomView];
        }
        [self initCollectionView];
        
        _isFirstAppear = NO;
        [self reloadCurrentCell];
    }
    
    [self resetEditBtnState];
    [self resetDelBtnState];
    
}

- (void)setModels:(NSArray<ZLPhotoModel *> *)models
{
    _models = models;
    //如果预览数组中存在网络图片/视频则返回
    for (ZLPhotoModel *m in models) {
        if (m.type == ZLAssetMediaTypeNetImage ||
            m.type == ZLAssetMediaTypeNetVideo) {
            return;
        }
    }
    
    if (self.arrSelPhotos) {
        _arrSelAssets = [NSMutableArray array];
        for (ZLPhotoModel *m in models) {
            [_arrSelAssets addObject:m.asset];
        }
        _arrSelAssetsBackup = _arrSelAssets.copy;
    }
}

- (void)setArrSelPhotos:(NSMutableArray *)arrSelPhotos
{
    _arrSelPhotos = arrSelPhotos;
    _arrSelPhotosBackup = arrSelPhotos.copy;
}

#pragma mark - UI
- (void)initNavView
{
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, GC.navBarHeight)];
    _navView.backgroundColor = _configuration.navBarColor;
    [self.view addSubview:_navView];
    
    _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(7, _navView.frame.size.height - 44, 44, 44)];
    [_btnBack setImage:_configuration.leftImage forState:UIControlStateNormal];
    _btnBack.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_btnBack addTarget:self action:@selector(btnBack_Click) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_btnBack];
    
    if (self.isBigImageView) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _navView.frame.size.height - 42, _navView.frame.size.width, 40)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = self.titleStr;
        [_navView addSubview:_titleLabel];
        
        if (self.models.count > 1) {
            if (IPHONE_X) {
                // iPhoneX系列
                _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 30, self.view.frame.size.height - 44 - 34, 60, 24)];
            } else {
                _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 30, self.view.frame.size.height - 44, 60, 24)];
            }
            _indexLabel.font = [UIFont systemFontOfSize:15];
            _indexLabel.textColor = [UIColor whiteColor];
            _indexLabel.textAlignment = NSTextAlignmentCenter;
            _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentPage, self.models.count];
            _indexLabel.backgroundColor = kUIColorFromRGBAlpha(0x000000, 0.7);
            _indexLabel.layer.masksToBounds = YES;
            _indexLabel.layer.cornerRadius = 12;
            [self.view addSubview:_indexLabel];
        }
        
        
        if (_configuration.rightImage) {
            _navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _navRightBtn.frame = CGRectMake(self.view.frame.size.width - 51, _navView.frame.size.height - 44, 44, 44);
            [_navRightBtn setImage:_configuration.rightImage forState:UIControlStateNormal];
            _navRightBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            [_navRightBtn addTarget:self action:@selector(navRightBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
            [_navView addSubview:_navRightBtn];
        }
        
        
    }else {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _navView.frame.size.height - 42, _navView.frame.size.width, 40)];
        _indexLabel.font = [UIFont systemFontOfSize:18];
        _indexLabel.textColor = GC.MC;
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        if (self.selectPhotoType) {
            _indexLabel.text = ML(@"图片");
        }else {
            _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentPage, self.models.count];
        }
        
        [_navView addSubview:_indexLabel];
    }
    
    
    if (self.hideToolBar || (!_configuration.showSelectBtn && !self.arrSelPhotos.count) && !self.selectPhotoType) {
        return;
    }
    
    //right nav btn
    _navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (self.selectPhotoType) {
        _navRightBtn.frame = CGRectMake(self.view.frame.size.width - 70, _navView.frame.size.height - 40, 60, 40);
        [_navRightBtn setTitle:ML(@"确定") forState:UIControlStateNormal];
        [_navRightBtn setTitleColor:GC.MC forState:UIControlStateNormal];
        [_navRightBtn addTarget:self action:@selector(navRightBtn_SinglePhotoSureClick:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        _navRightBtn.frame = CGRectMake(self.view.frame.size.width - 40, _navView.frame.size.height - 40, 40, 40);
        [_navRightBtn setImage:_configuration.selectImage forState:UIControlStateNormal];
        [_navRightBtn setImage:_configuration.selectInImage forState:UIControlStateSelected];
        if (self.models.count == 1) {
            _navRightBtn.selected = self.models.firstObject.isSelected;
        }
        ZLPhotoModel *model = self.models[_currentPage-1];
        _navRightBtn.selected = model.isSelected;
        [_navRightBtn addTarget:self action:@selector(navRightBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_navView addSubview:_navRightBtn];
}

- (void)initCollectionView
{
    CGRect frame = self.view.frame;
    if (_navView) {
        frame.origin.y = CGRectGetMaxY(_navView.frame);
        frame.size.height -= CGRectGetMaxY(_navView.frame);
    }
    if (_bottomView) {
        frame.size.height -= _bottomView.frame.size.height;
    }
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.itemSize = frame.size;
    _layout.minimumLineSpacing = 0;
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:_layout];
    [_collectionView registerClass:[ZLBigImageCell class] forCellWithReuseIdentifier:@"ZLBigImageCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    [self.view sendSubviewToBack:_collectionView];
    
    [_collectionView setContentOffset:CGPointMake(_collectionView.frame.size.width * _indexBeforeRotation, 0)];
    
    if (self.isBigImageView) {
        [self.view bringSubviewToFront:_indexLabel];
    }
}

- (void)initBottomView
{
    if (self.hideToolBar) return;
    
    if (IPHONE_X) {
        // iPhoneX系列
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44 - 34, self.view.frame.size.width, 44 + 34)];
    } else {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    }
    
    _bottomView.backgroundColor = _configuration.bottomViewBgColor;
    [self.view addSubview:_bottomView];
    
    _btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnEdit.frame = CGRectMake(_bottomView.frame.size.width - 82, 7, 70, 30);
    [_btnEdit setTitleColor:GC.CWhite forState:UIControlStateNormal];
    _btnEdit.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnEdit setTitle:ML(@"编辑") forState:UIControlStateNormal];
    _btnEdit.layer.masksToBounds = YES;
    _btnEdit.layer.cornerRadius = 3.0f;
    [_btnEdit setBackgroundColor:GC.MC];
    [_btnEdit addTarget:self action:@selector(btnEdit_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnEdit];
    
    _delEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    _delEdit.frame = CGRectMake((_bottomView.frame.size.width - 70) / 2, 7, 70, 30);
    [_delEdit setTitleColor:GC.CWhite forState:UIControlStateNormal];
    _delEdit.titleLabel.font = [UIFont systemFontOfSize:15];
    [_delEdit setTitle:ML(@"删除") forState:UIControlStateNormal];
    _delEdit.layer.masksToBounds = YES;
    _delEdit.layer.cornerRadius = 3.0f;
    [_delEdit setBackgroundColor:GC.MC];
    [_delEdit addTarget:self action:@selector(btnDel_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_delEdit];
    
}

#pragma mark - UIButton Actions
- (void)btnEdit_Click:(UIButton *)btn
{
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    
    if (nav.arrSelectedModels.count >= _configuration.maxSelectCount) {
        ShowToastLong(ML(@"已经达到选择上限"));
        return;
    }
    
    ZLPhotoModel *model = self.models[_currentPage-1];
    
    if (model.type == ZLAssetMediaTypeVideo) {
        NSInteger v_count = 0;
        for (ZLPhotoModel *one in nav.arrSelectedModels) {
            if (one.type == ZLAssetMediaTypeVideo) {
                v_count++;
            }
        }
        
        if (v_count >= _configuration.maxSelectVideoCount) {
            ShowToastLong(ML(@"视频选择已达上限"));
            return;
        }
    }
    
    if (![ZLPhotoManager judgeAssetisInLocalAblum:model.asset]) {
        ShowToastLong(ML(@"尚未从iCloud上下载，请下载完毕后选择"));
        return;
    }
    
    if (model.type == ZLAssetMediaTypeVideo) {
        ZLEditVideoController *vc = [[ZLEditVideoController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:NO];
        
    } else if (model.type == ZLAssetMediaTypeImage ||
               (model.type == ZLAssetMediaTypeGif && !_configuration.allowSelectGif) ||
               (model.type == ZLAssetMediaTypeLivePhoto && !_configuration.allowSelectLivePhoto)) {
        ZLEditViewController *vc = [[ZLEditViewController alloc] init];
        vc.model = model;
        ZLBigImageCell *cell = (ZLBigImageCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage-1 inSection:0]];
        vc.oriImage = cell.previewView.image;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)btnDel_Click:(UIButton *)btn
{
    WPNormalPopView *popView = [[WPNormalPopView alloc]initWithTitle:ML(@"确定删除") cancelBtnTitle:ML(@"取消") okBtnTitle:ML(@"确定") makeSure:^{
        
        ZLPhotoModel *model = self.models[_currentPage-1];
        if (self.delPreviewBlock) {
            self.delPreviewBlock(model);
        }
        
        if ([self.models count] == 1) {
            [self btnBack_Click];
            
        } else {
            NSMutableArray *mList = [self.models mutableCopy];
            [mList removeObject:model];
            self.models = [mList copy];
            _currentPage--;
            
            if (_currentPage < 1) {
                _currentPage = 1;
            }
            
            [_collectionView reloadData];
            
            [self getCurrentPageModel];
            _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentPage, self.models.count];
        }
        
    } cancel:^{
        
    }];
    [popView showPopView];
    
}

- (void)btnBack_Click
{
    // 如果在播放视频先释放视频
    NSArray <ZLBigImageCell *> *cells = [_collectionView visibleCells];
    for (ZLBigImageCell *one in cells) {
        [one resetCellStatus];
        if (one.previewView) {
            [one.previewView handlerEndDisplaying];
            [one.previewView pausePlay];
        }
    }
    
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    if (self.finishBackBlock) {
        self.finishBackBlock(nav.arrSelectedModels, YES);
    }
    
    if (self.cancelPreviewBlock) {
        self.cancelPreviewBlock();
    }
}

- (void)navRightBtn_Click:(UIButton *)btn
{
    if (_isBigImageView) {
        
        if (self.fromVType == FromPersonAvaVCType) {
            
            BottomPopView *selectView = [[BottomPopView alloc]initWithSelectArr:@[ML(@"拍照"),ML(@"从相册选择")] selectIndex:0];
            [selectView showPopView];
            selectView.selectType = ^(NSInteger tag) {
                
                if (self.rightButtonTagIndex) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self btnBack_Click];
                    });
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.rightButtonTagIndex(tag);
                    });
                    
                }
            };
        }
        
        return;
    }
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    
    ZLPhotoModel *model = self.models[_currentPage-1];
    
    if (!btn.selected) {
        //选中
        [btn.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
        if (nav.arrSelectedModels.count >= _configuration.maxSelectCount) {
            ShowToastLong(ML(@"已经达到选择上限"), _configuration.maxSelectCount);
            return;
        }
        if (model.type == ZLAssetMediaTypeVideo) {
            NSInteger v_count = 0;
            for (ZLPhotoModel *one in nav.arrSelectedModels) {
                if (one.type == ZLAssetMediaTypeVideo) {
                    v_count++;
                }
            }
            
            if (v_count >= _configuration.maxSelectVideoCount) {
                ShowToastLong(ML(@"视频选择已达上限"));
                return;
            }
        }
        if (model.asset && ![ZLPhotoManager judgeAssetisInLocalAblum:model.asset]) {
            ShowToastLong(ML(@"尚未从iCloud上下载，请下载完毕后选择"));
            return;
        }
        if (model.type == ZLAssetMediaTypeVideo && GetDuration(model.duration) > _configuration.maxVideoDuration) {
            ShowToastLong(@"无法上传大小超过%ld秒的视频", _configuration.maxVideoDuration);
            return;
        }
        
        model.selected = YES;
        [nav.arrSelectedModels addObject:model];
        if (self.arrSelPhotos) {
            [self.arrSelPhotos addObject:_arrSelPhotosBackup[_currentPage-1]];
            [_arrSelAssets addObject:_arrSelAssetsBackup[_currentPage-1]];
        }
    } else {
        //移除
        model.selected = NO;
        for (ZLPhotoModel *m in nav.arrSelectedModels) {
            if ([m.asset.localIdentifier isEqualToString:model.asset.localIdentifier] ||
                [m.image isEqual:model.image] ||
                [m.url.absoluteString isEqualToString:model.url.absoluteString]) {
                [nav.arrSelectedModels removeObject:m];
                break;
            }
        }
        if (self.arrSelPhotos) {
            for (PHAsset *asset in _arrSelAssets) {
                if ([asset isEqual:_arrSelAssetsBackup[_currentPage-1]]) {
                    [_arrSelAssets removeObject:asset];
                    break;
                }
            }
            [self.arrSelPhotos removeObject:_arrSelPhotosBackup[_currentPage-1]];
        }
    }
    
    btn.selected = !btn.selected;
    [self getPhotosBytes];
    [self resetEditBtnState];
    [self resetDelBtnState];
}

- (void)navRightBtn_SinglePhotoSureClick:(UIButton *)sender {
    
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    ZLPhotoModel *model = self.models[_currentPage-1];
    model.selected = YES;
    
    [nav.arrSelectedModels addObject:model];
    if (self.arrSelPhotos) {
        [self.arrSelPhotos addObject:_arrSelPhotosBackup[_currentPage-1]];
        [_arrSelAssets addObject:_arrSelAssetsBackup[_currentPage-1]];
    }
    
    if (self.finishBackBlock) {
        self.finishBackBlock(nav.arrSelectedModels, YES);
    }
    
    if (self.cancelPreviewBlock) {
        self.cancelPreviewBlock();
    }
}

#pragma mark - 更新按钮、导航条等显示状态
- (void)resetEditBtnState
{
    if (!_configuration.allowEditImage && !_configuration.allowEditVideo) {
        _btnEdit.hidden = YES;
        return;
    }
    
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    
    ZLPhotoModel *m = self.models[_currentPage-1];
    BOOL flag = NO;
    for (ZLPhotoModel *one in nav.arrSelectedModels) {
        if ([one.asset.localIdentifier isEqualToString:m.asset.localIdentifier]) {
            flag = YES;
            break;
        }
    }
    
    if (!flag &&
        
        ((_configuration.allowEditImage &&
          (m.type == ZLAssetMediaTypeImage ||
           (m.type == ZLAssetMediaTypeGif && !_configuration.allowSelectGif) ||
           (m.type == ZLAssetMediaTypeLivePhoto && !_configuration.allowSelectLivePhoto))) ||
         
         (_configuration.allowEditVideo && m.type == ZLAssetMediaTypeVideo))) {      //&& round(m.asset.duration) >= _configuration.maxEditVideoTime
            _btnEdit.hidden = NO;
        } else {
            _btnEdit.hidden = YES;
        }
}

- (void)resetDelBtnState
{
    if (!_configuration.allowDelEdit) {
        _delEdit.hidden = YES;
        return;
    }
    
    _delEdit.hidden = NO;
}

- (void)getPhotosBytes
{
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    
    NSArray *arr = _configuration.showSelectBtn?nav.arrSelectedModels:@[self.models[_currentPage-1]];
    
    if (arr.count) {
        zl_weakify(self);
        [ZLPhotoManager getPhotosBytesWithArray:arr completion:^(NSString *photosBytes) {
            zl_strongify(weakSelf);
            strongSelf.labPhotosBytes.text = [NSString stringWithFormat:@"(%@)", photosBytes];
        }];
    } else {
        self.labPhotosBytes.text = nil;
    }
}

- (void)handlerSingleTap
{
    _hideNavBar = !_hideNavBar;
    
    _navView.hidden = _hideNavBar;
    _bottomView.hidden = _hideNavBar;
}

- (void)showDownloadAlert:(id)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (msg && [msg isKindOfClass:[UIImage class]]) {
        
        if (_longShareBlock) {
            zl_weakify(self);
            UIAlertAction *share = [UIAlertAction actionWithTitle:ML(@"生成云店货品分享图") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                zl_strongify(weakSelf);
                __block toPage = 0;
                ZLPhotoModel *model = strongSelf.models[0];
                if (model.type == ZLAssetMediaTypeNetVideo) {
                    toPage = _currentPage - 2;
                } else {
                    toPage = _currentPage - 1;
                }
                
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    _longShareBlock(msg, toPage);
                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [strongSelf btnBack_Click];
                });
            }];
            
            [alert addAction:share];
        }
        
        UIAlertAction *save = [UIAlertAction actionWithTitle:ML(@"保存图片") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
            [hud show];
            
            [ZLPhotoManager saveImageToAblum:msg completion:^(BOOL suc, PHAsset *asset) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide];
                    if (!suc) {
                        ShowToastLong(@"保存失败");
                    }
                });
            }];
        }];
        
        [alert addAction:save];
        
    } else if (msg && [msg isKindOfClass:[NSString class]]) {
        UIAlertAction *save = [UIAlertAction actionWithTitle:ML(@"保存视频") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
            [hud show];
            
            [ZLPhotoManager saveVideoToAblum:[NSURL fileURLWithPath:msg] completion:^(BOOL suc, PHAsset *asset) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide];
                    if (!suc) {
                        ShowToastLong(@"保存失败");
                    }
                });
            }];
        }];
        
        [alert addAction:save];
        
    } else {
        return;
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:ML(@"取消") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)  {
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.frame),
                                                                    CGRectGetMidY(self.view.frame),
                                                                    2, 2);
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self showDetailViewController:alert sender:nil];
}

#pragma mark - UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [((ZLBigImageCell *)cell) resetCellStatus];
    ((ZLBigImageCell *)cell).willDisplaying = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [((ZLBigImageCell *)cell) resetCellStatus];
    [((ZLBigImageCell *)cell).previewView handlerEndDisplaying];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLBigImageCell" forIndexPath:indexPath];
    
    cell.playIcon = _configuration.playVideoImage;
    cell.showGif = _configuration.allowSelectGif;
    cell.showLivePhoto = _configuration.allowSelectLivePhoto;
    zl_weakify(self);
    cell.singleTapCallBack = ^() {
        zl_strongify(weakSelf);
        if (strongSelf.hideToolBar) {
            [strongSelf btnBack_Click];
        } else {
            [strongSelf handlerSingleTap];
        }
    };
    
    __weak typeof(cell) weakCell = cell;
    cell.longPressCallBack = ^{
        zl_strongify(weakSelf);
        __strong typeof(weakCell) strongCell = weakCell;
        if (strongCell.previewView.image) {
            [strongSelf showDownloadAlert:strongCell.previewView.image];
            
        } else if (strongCell.model.type == ZLAssetMediaTypeNetVideo) {
            NSString *fileName = strongCell.model.url.lastPathComponent;
            if (![fileName hasSuffix:@".mp4"]) {
                fileName = [fileName stringByAppendingString:@".mp4"];
            }
            
            if ([FileUseOther OperatingIsInFile:fileName]) {
                [strongSelf showDownloadAlert:[FileUseOther OperatingRouteFile:fileName]];
            }
        }
        
    };
    
    ZLPhotoModel *model = self.models[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == (UIScrollView *)_collectionView) {
        ZLPhotoModel *m = [self getCurrentPageModel];
        if (!m) return;
        
        if (m.type == ZLAssetMediaTypeGif ||
            m.type == ZLAssetMediaTypeLivePhoto ||
            m.type == ZLAssetMediaTypeVideo ||
            m.type == ZLAssetMediaTypeNetVideo) {
            ZLBigImageCell *cell = (ZLBigImageCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage-1 inSection:0]];
            [cell pausePlay];
        }
        
        if ([_modelIdentifile isEqualToString:m.asset.localIdentifier]) return;
        
        _modelIdentifile = m.asset.localIdentifier;
        //改变导航标题
        if (self.selectPhotoType) {
            _indexLabel.text = ML(@"图片");
        }else {
            _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentPage, self.models.count];
        }
        
        _navRightBtn.selected = m.isSelected;
        
        [self resetEditBtnState];
        [self resetDelBtnState];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //单选模式下获取当前图片大小
    if (!_configuration.showSelectBtn) [self getPhotosBytes];
    
    [self reloadCurrentCell];
}

- (void)reloadCurrentCell
{
    ZLPhotoModel *m = [self getCurrentPageModel];
    if (m.type == ZLAssetMediaTypeGif ||
        m.type == ZLAssetMediaTypeLivePhoto) {
        ZLBigImageCell *cell = (ZLBigImageCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage-1 inSection:0]];
        [cell reloadGifLivePhoto];
    }
}

- (ZLPhotoModel *)getCurrentPageModel
{
    CGPoint offset = _collectionView.contentOffset;
    
    CGFloat page = offset.x / _collectionView.frame.size.width;
    
    if (ceilf(page) >= self.models.count) {
        return nil;
    }
    NSString *str = [NSString stringWithFormat:@"%.0f", page];
    _currentPage = str.integerValue + 1;
    ZLPhotoModel *model = self.models[_currentPage-1];
    return model;
}

@end

