//
//  PhotoSelectController.m
//  Expecta
//
//  Created by zhang yyuan on 2018/7/5.
//

#import "PhotoSelectController.h"

#import <Photos/Photos.h>
#import "ZLDefine.h"
#import "ZLCollectionCell.h"
#import "ZLPhotoManager.h"

#import "BigImgViewController.h"

#import "ToastUtils.h"
#import "ZLProgressHUD.h"
#import "ZLForceTouchPreviewController.h"
#import "ZLEditViewController.h"
#import "ZLEditVideoController.h"
#import "ZLCustomCamera.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "PhotoNavigationController.h"
#import "ZLPhotoConfiguration.h"


#import <KPFoundation/KPFoundation.h>

typedef NS_ENUM(NSUInteger, SlideSelectType) {
    SlideSelectTypeNone,
    SlideSelectTypeSelect,
    SlideSelectTypeCancel,
};

@interface PhotoSelectController ()<UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIViewControllerPreviewingDelegate>
{
    BOOL _isLayoutOK;
    
    //设备旋转前的第一个可视indexPath
    NSIndexPath *_visibleIndexPath;
    //是否切换横竖屏
    BOOL _switchOrientation;
    
    //开始滑动选择 或 取消
    BOOL _beginSelect;
    /**
     滑动选择 或 取消
     当初始滑动的cell处于未选择状态，则开始选择，反之，则开始取消选择
     */
    SlideSelectType _selectType;
    /**开始滑动的indexPath*/
    NSIndexPath *_beginSlideIndexPath;
    /**最后滑动经过的index，开始的indexPath不计入，优化拖动手势计算，避免单个cell中冗余计算多次*/
    NSInteger _lastSlideIndex;
}

@property (nonatomic, strong) NSMutableArray<ZLPhotoModel *> *arrDataSources;
@property (nonatomic, assign) BOOL allowTakePhoto;
/**所有滑动经过的indexPath*/
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *arrSlideIndexPath;
/**所有滑动经过的indexPath的初始选择状态*/
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *dicOriSelectStatus;

@end

@implementation PhotoSelectController


- (void)dealloc
{
    //    NSLog(@"---- %s", __FUNCTION__);
}

- (NSMutableArray<NSIndexPath *> *)arrSlideIndexPath
{
    if (!_arrSlideIndexPath) {
        _arrSlideIndexPath = [NSMutableArray array];
    }
    return _arrSlideIndexPath;
}

- (NSMutableDictionary<NSString *, NSNumber *> *)dicOriSelectStatus
{
    if (!_dicOriSelectStatus) {
        _dicOriSelectStatus = [NSMutableDictionary dictionary];
    }
    return _dicOriSelectStatus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_arrDataSources) {
        [self resetBottomBtnsStatus:NO];
        
    } else {
        ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
        [hud show];
        
        ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
        
        if (!_albumListModel) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                zl_weakify(self);
                [ZLPhotoManager getCameraRollAlbumList:configuration.allowSelectVideo allowSelectImage:configuration.allowSelectImage complete:^(ZLAlbumListModel *album) {
                    zl_strongify(weakSelf);
                    PhotoNavigationController *weakNav = (PhotoNavigationController *)strongSelf.navigationController;
                    
                    strongSelf.albumListModel = album;
                    [ZLPhotoManager markSelectModelInArr:strongSelf.albumListModel.models selArr:weakNav.arrSelectedModels];
                    strongSelf.arrDataSources = [NSMutableArray arrayWithArray:strongSelf.albumListModel.models];
                    [hud hide];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadUI];
                    });
                }];
            });
        } else {
            if (configuration.allowTakePhotoInLibrary && (configuration.allowSelectImage || configuration.allowRecordVideo) && self.albumListModel.isCameraRoll) {
                self.allowTakePhoto = YES;
            }
            [ZLPhotoManager markSelectModelInArr:self.albumListModel.models selArr:((PhotoNavigationController *)self.navigationController).arrSelectedModels];
            _arrDataSources = [NSMutableArray arrayWithArray:self.albumListModel.models];
            [hud hide];
            
            [self loadUI];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _isLayoutOK = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!_isLayoutOK && self.albumListModel) {
        [self scrollToBottom];
    } else if (_switchOrientation) {
        _switchOrientation = NO;
        [self.collectionView scrollToItemAtIndexPath:_visibleIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
}

- (void)reloadCollectionViewFrowOutSideWithAddModel:(ZLPhotoModel *)model{
    //    if (model) {
    //        [self.arrDataSources insertObject:model atIndex:0];
    //    }
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    [ZLPhotoManager markSelectModelInArr:self.arrDataSources selArr:nav.arrSelectedModels];
    [self handleDataArray:model];
    
    //[self.collectionView reloadData];
    
}

// 从外部调用 重新加载列表
- (void)reloadCollectionViewFrowOutSide {
    
    ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
    [hud show];
    
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    
    if (!_albumListModel) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            zl_weakify(self);
            [ZLPhotoManager getCameraRollAlbumList:configuration.allowSelectVideo allowSelectImage:configuration.allowSelectImage complete:^(ZLAlbumListModel *album) {
                zl_strongify(weakSelf);
                PhotoNavigationController *weakNav = (PhotoNavigationController *)strongSelf.navigationController;
                
                strongSelf.albumListModel = album;
                [ZLPhotoManager markSelectModelInArr:strongSelf.albumListModel.models selArr:weakNav.arrSelectedModels];
                strongSelf.arrDataSources = [NSMutableArray arrayWithArray:strongSelf.albumListModel.models];
                [hud hide];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadUI];
                });
            }];
        });
    } else {
        if (configuration.allowTakePhotoInLibrary && (configuration.allowSelectImage || configuration.allowRecordVideo) && self.albumListModel.isCameraRoll) {
            self.allowTakePhoto = YES;
        }
        [ZLPhotoManager markSelectModelInArr:self.albumListModel.models selArr:((PhotoNavigationController *)self.navigationController).arrSelectedModels];
        _arrDataSources = [NSMutableArray arrayWithArray:self.albumListModel.models];
        [hud hide];
        
        [self loadUI];
    }
    
}

#pragma mark - UI
- (void)loadUI {
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    
    if (configuration.allowTakePhotoInLibrary && (configuration.allowSelectImage || configuration.allowRecordVideo)) {
        self.allowTakePhoto = YES;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavBtn];
    [self setupCollectionView];
    [self setupBottomView];
    
}

- (void)initNavBtn
{
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    
    self.customTitleStr = self.albumListModel.title;
    
    [self addLeftBarButtonItem:configuration.leftImage];
    
    [self addRightBarButtonItem:ML(@"取消")];
}

- (void)setupCollectionView
{
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    
    CGFloat width = MIN(kViewWidth, kViewHeight);
    
    NSInteger columnCount;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        columnCount = 6;
    } else {
        columnCount = 4;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((width-1.5*columnCount)/columnCount, (width-1.5*columnCount)/columnCount);
    layout.minimumInteritemSpacing = 1.5;
    layout.minimumLineSpacing = 1.5;
    layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
    
    if (self.collectionView) {
        [self.collectionView reloadData];
    }else {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.customNavBar.height, self.view.frame.size.width, self.view.frame.size.height - configuration.bottomHeight - self.customNavBar.height) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        if (@available(iOS 11.0, *)) {
            [self.collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
        }
        [self.view addSubview:self.collectionView];
        
        [self.collectionView registerClass:NSClassFromString(@"ZLTakePhotoCell") forCellWithReuseIdentifier:@"ZLTakePhotoCell"];
        [self.collectionView registerClass:NSClassFromString(@"ZLCollectionCell") forCellWithReuseIdentifier:@"ZLCollectionCell"];
        
        //注册3d touch
        if (configuration.allowForceTouch && [self forceTouchAvailable]) {
            [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
        }
    }
    
    
    
}

- (void)setupBottomView
{
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    if (self.bottomView) {
        return;
    }
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - configuration.bottomHeight, self.view.frame.size.width, configuration.bottomHeight)];
    self.bottomView.backgroundColor = configuration.bottomViewBgColor;
    [self.view addSubview:self.bottomView];
    
    [GeneralUIUse AddLineUp:self.bottomView Color:GC.LINE LeftOri:0 RightOri:0];
    
    self.btnDone = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - configuration.bottomHeight + (configuration.bottomHeight - configuration.bottomImageSize)/2, (configuration.bottomHeight - configuration.bottomImageSize)/2, configuration.bottomImageSize, configuration.bottomImageSize)];
    self.btnDone.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.btnDone.titleLabel setNumberOfLines:2];
    [self.btnDone setTitleColor:GC.CWhite forState:UIControlStateDisabled];
    [self.btnDone addTarget:self action:@selector(btnDone_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.btnDone];
    
    UIScrollView *scrollImage = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bottomView.frame.size.width - self.bottomView.frame.size.height, self.bottomView.frame.size.height)];
    [scrollImage setBackgroundColor:[UIColor clearColor]];
    [self.bottomView addSubview:scrollImage];
    
    [self resetBottomBtnsStatus:NO];
    
    if (configuration.allowSelectOriginal) {
        self.btnOriginalPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnOriginalPhoto.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btnOriginalPhoto setImage:GetImageWithName(@"zl_btn_original_circle") forState:UIControlStateNormal];
        [self.btnOriginalPhoto setImage:GetImageWithName(@"zl_btn_selected") forState:UIControlStateSelected];
        [self.btnOriginalPhoto setTitle:ML(@"原图") forState:UIControlStateNormal];
        [self.btnOriginalPhoto addTarget:self action:@selector(btnOriginalPhoto_Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.btnOriginalPhoto];
        
        self.labPhotosBytes = [[UILabel alloc] init];
        self.labPhotosBytes.font = [UIFont systemFontOfSize:15];
        self.labPhotosBytes.textColor = configuration.bottomBtnsNormalTitleColor;
        [self.bottomView addSubview:self.labPhotosBytes];
    }
    
}
- (void)resetBottomBtnsStatus:(BOOL)getBytes
{
    UIScrollView *scrollImage = nil;
    for (id view in [self.bottomView subviews]) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollImage = view;
            break;
        }
    }
    
    if (scrollImage) {
        while (scrollImage.subviews.count) {
            UIView *child = scrollImage.subviews.lastObject;
            [child removeFromSuperview];
        }
    }
    
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    
    if (((PhotoNavigationController *)self.navigationController).arrSelectedModels.count > 0) {
        
        for (NSInteger i = 0; i < ((PhotoNavigationController *)self.navigationController).arrSelectedModels.count; i++) {
            __block ZLPhotoModel *pModel = ((PhotoNavigationController *)self.navigationController).arrSelectedModels[i];
            
            EditPhotoCell *eBtn = [[EditPhotoCell alloc] initWithFrame:CGRectMake(10 + i * (configuration.bottomImageSize + 10), (configuration.bottomHeight - configuration.bottomImageSize)/2, configuration.bottomImageSize, configuration.bottomImageSize)];
            eBtn.configuration = configuration;
            [eBtn setTag:i+1];
            [eBtn addTarget:self action:@selector(btnPreview_Click:) forControlEvents:(UIControlEventTouchUpInside)];
            
            zl_weakify(self);
            __weak typeof(eBtn) weakCell = eBtn;
            
            eBtn.delBlock = ^() {
                zl_strongify(weakSelf);
                __strong typeof(weakCell) strongCell = weakCell;
                
                PhotoNavigationController *weakNav = (PhotoNavigationController *)strongSelf.navigationController;
                pModel.selected = NO;
                for (ZLPhotoModel *m in weakNav.arrSelectedModels) {
                    if ([m.asset.localIdentifier isEqualToString:pModel.asset.localIdentifier]) {
                        [weakNav.arrSelectedModels removeObject:m];
                        break;
                    }
                }
                if (configuration.showSelectedMask) {
                    strongCell.topView.hidden = !pModel.isSelected;
                }
                [strongSelf resetBottomBtnsStatus:NO];
                [ZLPhotoManager markSelectModelInArr:strongSelf.arrDataSources selArr:weakNav.arrSelectedModels];
                [strongSelf.collectionView reloadData];
            };
            
            eBtn.allSelectGif = configuration.allowSelectGif;
            eBtn.allSelectLivePhoto = configuration.allowSelectLivePhoto;
            eBtn.showSelectBtn = configuration.showSelectBtn;
            eBtn.cornerRadio = configuration.cellCornerRadio;
            eBtn.showMask = configuration.showSelectedMask;
            eBtn.maskColor = configuration.selectedMaskColor;
            eBtn.model = pModel;
            
            [scrollImage addSubview:eBtn];
        }
        
        [scrollImage setContentSize:CGSizeMake(((PhotoNavigationController *)self.navigationController).arrSelectedModels.count * (configuration.bottomImageSize + 10), scrollImage.frame.size.height)];
        
        self.btnOriginalPhoto.enabled = YES;
        self.btnDone.enabled = YES;
        
        if (getBytes) [self getOriginalImageBytes];
        
        [self.btnDone setTitle:[NSString stringWithFormat:@"%@\n(%ld/%ld)", ML(@"确定"), ((PhotoNavigationController *)self.navigationController).arrSelectedModels.count ,configuration.maxSelectCount] forState:UIControlStateNormal];
        self.btnDone.backgroundColor = GC.MC;
        [self.btnOriginalPhoto setTitleColor:configuration.bottomBtnsNormalTitleColor forState:UIControlStateNormal];
        
    } else {
        self.btnOriginalPhoto.selected = NO;
        self.btnOriginalPhoto.enabled = NO;
        self.btnDone.enabled = NO;
        [self.btnDone setTitle:ML(@"确定") forState:UIControlStateDisabled];
        self.btnDone.backgroundColor = configuration.bottomBtnsDisableBgColor;
        [self.btnOriginalPhoto setTitleColor:configuration.bottomBtnsDisableBgColor forState:UIControlStateDisabled];
        self.labPhotosBytes.text = nil;
        
    }
}

- (void)scrollToBottom
{
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    if (!configuration.sortAscending) {
        return;
    }
    if (self.arrDataSources.count > 0) {
        NSInteger index = self.arrDataSources.count-1;
        if (self.allowTakePhoto) {
            index += 1;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - 设备旋转

- (BOOL)forceTouchAvailable
{
    if (@available(iOS 9.0, *)) {
        return self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    } else {
        return NO;
    }
}

#pragma mark - UIButton Action
- (void)btnEdit_Click:(id)sender {
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    ZLPhotoModel *m = nav.arrSelectedModels.firstObject;
    
    if (m.type == ZLAssetMediaTypeVideo) {
        ZLEditVideoController *vc = [[ZLEditVideoController alloc] init];
        vc.model = m;
        [self.navigationController pushViewController:vc animated:NO];
    } else if (m.type == ZLAssetMediaTypeImage ||
               m.type == ZLAssetMediaTypeGif ||
               m.type == ZLAssetMediaTypeLivePhoto) {
        ZLEditViewController *vc = [[ZLEditViewController alloc] init];
        vc.model = m;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)btnPreview_Click:(UIButton *)sender
{
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    UIViewController *vc = [self getBigImageVCWithData:nav.arrSelectedModels index:sender.tag - 1];
    [self.navigationController showViewController:vc sender:nil];
}
- (UIViewController *)getBigImageVCWithData:(NSArray<ZLPhotoModel *> *)data index:(NSInteger)index
{
    BigImgViewController *vc = [[BigImgViewController alloc] init];
    vc.selectPhotoType = self.selectPhotoType;
    vc.configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    vc.models = data.copy;
    vc.selectIndex = index;
    vc.unNeedNav = YES;
    zl_weakify(self);
    [vc setFinishBackBlock:^(NSArray<ZLPhotoModel *> *selectedModels, BOOL isOriginal) {
        zl_strongify(weakSelf);
        if (strongSelf.selectPhotoType) {
            if (selectedModels.count) {
                [strongSelf.navigationController popViewControllerAnimated:NO];
                [ZLPhotoManager markSelectModelInArr:strongSelf.arrDataSources selArr:selectedModels];
                
                [self btnDone_Click:nil];
            }else {
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
            
            
        }else {
            [strongSelf.navigationController popViewControllerAnimated:YES];
            [ZLPhotoManager markSelectModelInArr:strongSelf.arrDataSources selArr:selectedModels];
            [strongSelf.collectionView reloadData];
        }
    }];
    return vc;
}

- (void)btnOriginalPhoto_Click:(id)sender
{
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    self.btnOriginalPhoto.selected = !self.btnOriginalPhoto.selected;
    
    [self getOriginalImageBytes];
}

- (void)btnDone_Click:(id)sender
{
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    if (nav.callSelectImageBlock) {
        nav.callSelectImageBlock();
    }
}

- (void)rightBarButtonItemClicked:(UIBarButtonItem *)barButtonItem
{
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    if (nav.cancelBlock) {
        nav.cancelBlock();
    }
    [nav dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)canAddModel:(ZLPhotoModel *)model
{
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    
    if (((PhotoNavigationController *)self.navigationController).arrSelectedModels.count >= configuration.maxSelectCount) {
        ShowToastLong(ML(@"已经达到选择上限"), configuration.maxSelectCount);
        return NO;
    }
    
    if (model.type == ZLAssetMediaTypeVideo) {
        NSInteger v_count = 0;
        for (ZLPhotoModel *one in ((PhotoNavigationController *)self.navigationController).arrSelectedModels) {
            if (one.type == ZLAssetMediaTypeVideo) {
                v_count++;
            }
        }
        
        if (v_count >= configuration.maxSelectVideoCount) {
            ShowToastLong(ML(@"视频选择已达上限"));
            return NO;
        }
    }
    
    if (![ZLPhotoManager judgeAssetisInLocalAblum:model.asset]) {
        ShowToastLong(ML(@"该图片或视频不在本地，确定后开始下载"));
        //return NO;
    }
    
    if (model.type == ZLAssetMediaTypeVideo && GetDuration(model.duration) > configuration.maxVideoDuration) {
        ShowToastLong(@"无法上传大小超过%ld秒的视频", configuration.maxVideoDuration);
        return NO;
    }
    
    return YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.allowTakePhoto) {
        return self.arrDataSources.count + 1;
    }
    return self.arrDataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    
    if (self.allowTakePhoto && ((configuration.sortAscending && indexPath.row >= self.arrDataSources.count) || (!configuration.sortAscending && indexPath.row == 0))) {
        ZLTakePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLTakePhotoCell" forIndexPath:indexPath];
        cell.configuration = configuration;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = configuration.cellCornerRadio;
        if (configuration.showCaptureImageOnTakePhotoBtn) {
            [cell startCapture];
        }
        return cell;
    }
    
    ZLCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLCollectionCell" forIndexPath:indexPath];
    cell.configuration = configuration;
    ZLPhotoModel *model;
    if (!self.allowTakePhoto || configuration.sortAscending) {
        model = self.arrDataSources[indexPath.row];
    } else {
        model = self.arrDataSources[indexPath.row-1];
    }
    
    zl_weakify(self);
    __weak typeof(cell) weakCell = cell;
    
    cell.selectedBlock = ^(BOOL selected) {
        zl_strongify(weakSelf);
        __strong typeof(weakCell) strongCell = weakCell;
        
        PhotoNavigationController *weakNav = (PhotoNavigationController *)strongSelf.navigationController;
        if (!selected) {
            //选中
            if ([strongSelf canAddModel:model]) {
                model.selected = YES;
                [weakNav.arrSelectedModels addObject:model];
                strongCell.btnSelect.selected = YES;
            }
        } else {
            strongCell.btnSelect.selected = NO;
            model.selected = NO;
            for (ZLPhotoModel *m in weakNav.arrSelectedModels) {
                if ([m.asset.localIdentifier isEqualToString:model.asset.localIdentifier]) {
                    [weakNav.arrSelectedModels removeObject:m];
                    break;
                }
            }
        }
        if (configuration.showSelectedMask) {
            strongCell.topView.hidden = !model.isSelected;
        }
        [strongSelf resetBottomBtnsStatus:NO];
    };
    
    cell.allSelectGif = configuration.allowSelectGif;
    cell.allSelectLivePhoto = configuration.allowSelectLivePhoto;
    cell.showSelectBtn = configuration.showSelectBtn;
    cell.cornerRadio = configuration.cellCornerRadio;
    cell.showMask = configuration.showSelectedMask;
    cell.maskColor = configuration.selectedMaskColor;
    cell.model = model;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    
    if (self.allowTakePhoto && ((configuration.sortAscending && indexPath.row >= self.arrDataSources.count) || (!configuration.sortAscending && indexPath.row == 0))) {
        //拍照
        [self takePhoto];
        return;
    }
    
    NSInteger index = indexPath.row;
    if (self.allowTakePhoto && !configuration.sortAscending) {
        index = indexPath.row - 1;
    }
    ZLPhotoModel *model = self.arrDataSources[index];
    
    if (configuration.allowEditImage && configuration.clipRatios && configuration.clipRatios.count == 1) {
        
        // 固定比例
        ZLEditViewController *vc = [[ZLEditViewController alloc] init];
        vc.model = model;
        vc.oriImage = model.image;
        vc.isFixedRatio = YES;
        vc.unGestureRecognizer = YES; //禁用返回手势
        [self.navigationController pushViewController:vc animated:NO];
        
    }else {
        UIViewController *vc = [self getMatchVCWithModel:model];
        if (vc) {
            [self showViewController:vc sender:nil];
        }
    }
}

/**
 获取对应的vc
 */
- (UIViewController *)getMatchVCWithModel:(ZLPhotoModel *)model
{
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    ZLPhotoConfiguration *configuration = [nav getConfiguration];
    
    if (nav.arrSelectedModels.count > 0) {
        ZLPhotoModel *sm = nav.arrSelectedModels.firstObject;
        if (!configuration.allowMixSelect &&
            ((model.type < ZLAssetMediaTypeVideo && sm.type == ZLAssetMediaTypeVideo) || (model.type == ZLAssetMediaTypeVideo && sm.type < ZLAssetMediaTypeVideo))) {
            ShowToastLong(@"ZLPhotoBrowserCannotSelectVideo");
            return nil;
        }
    }
    
    BOOL allowSelImage = !(model.type==ZLAssetMediaTypeVideo)?YES:configuration.allowMixSelect;
    BOOL allowSelVideo = model.type==ZLAssetMediaTypeVideo?YES:configuration.allowMixSelect;
    
    NSArray *arr = [ZLPhotoManager getPhotoInResult:self.albumListModel.result allowSelectVideo:allowSelVideo allowSelectImage:allowSelImage allowSelectGif:configuration.allowSelectGif allowSelectLivePhoto:configuration.allowSelectLivePhoto];
    
    NSMutableArray *selIdentifiers = [NSMutableArray array];
    for (ZLPhotoModel *m in nav.arrSelectedModels) {
        [selIdentifiers addObject:m.asset.localIdentifier];
    }
    
    int i = 0;
    BOOL isFind = NO;
    for (ZLPhotoModel *m in arr) {
        if ([m.asset.localIdentifier isEqualToString:model.asset.localIdentifier]) {
            isFind = YES;
        }
        if ([selIdentifiers containsObject:m.asset.localIdentifier]) {
            m.selected = YES;
        }
        if (!isFind) {
            i++;
        }
    }
    
    return [self getBigImageVCWithData:arr index:i];
}

- (void)takePhoto
{
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    
    if (![ZLPhotoManager haveCameraAuthority]) {
        NSString *message = ML(@"未开启拍照权限");
        ShowAlert(message, self);
        return;
    }
    if (!configuration.allowSelectImage &&
        !configuration.allowRecordVideo) {
        ShowAlert(@"allowSelectImage与allowRecordVideo不能同时为NO", self);
        return;
    }
    if (configuration.useSystemCamera) {
        //系统相机拍照
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSArray *a1 = configuration.allowSelectImage?@[(NSString *)kUTTypeImage]:@[];
            NSArray *a2 = (configuration.allowSelectVideo && configuration.allowRecordVideo)?@[(NSString *)kUTTypeMovie]:@[];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObjectsFromArray:a1];
            [arr addObjectsFromArray:a2];
            
            picker.mediaTypes = arr;
            picker.videoMaximumDuration = configuration.maxRecordDuration;
            [self showDetailViewController:picker sender:nil];
        }
    } else {
        if (![ZLPhotoManager haveMicrophoneAuthority]) {
            NSString *message = ML(@"未开启语音权限");
            ShowAlert(message, self);
            return;
        }
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
        zl_weakify(self);
        camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
            zl_strongify(weakSelf);
            [strongSelf saveImage:image videoUrl:videoUrl];
        };
        [self showDetailViewController:camera sender:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSURL *url = [info valueForKey:UIImagePickerControllerMediaURL];
        [self saveImage:image videoUrl:url];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image videoUrl:(NSURL *)videoUrl
{
    ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
    [hud show];
    zl_weakify(self);
    if (image) {
        [ZLPhotoManager saveImageToAblum:image completion:^(BOOL suc, PHAsset *asset) {
            zl_strongify(weakSelf);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (suc) {
                    ZLPhotoModel *model = [ZLPhotoModel modelWithAsset:asset type:ZLAssetMediaTypeImage duration:nil];
                    [strongSelf handleDataArray:model];
                } else {
                    ShowToastLong(@"图片保存失败");
                }
                [hud hide];
            });
        }];
    } else if (videoUrl) {
        [ZLPhotoManager saveVideoToAblum:videoUrl completion:^(BOOL suc, PHAsset *asset) {
            zl_strongify(weakSelf);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (suc) {
                    ZLPhotoModel *model = [ZLPhotoModel modelWithAsset:asset type:ZLAssetMediaTypeVideo duration:nil];
                    model.duration = [ZLPhotoManager getDuration:asset];
                    [strongSelf handleDataArray:model];
                    
                } else {
                    ShowToastLong(@"视频保存失败");
                }
                [hud hide];
            });
        }];
    }
}

- (void)handleDataArray:(ZLPhotoModel *)model
{
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    ZLPhotoConfiguration *configuration = [nav getConfiguration];
    
    BOOL (^shouldSelect)(void) = ^BOOL() {
        if (model.type == ZLAssetMediaTypeVideo) {
            return (model.asset.duration <= configuration.maxVideoDuration);
        }
        return YES;
    };
    
    if (configuration.sortAscending) {
        [self.arrDataSources addObject:model];
    } else {
        [self.arrDataSources insertObject:model atIndex:0];
    }
    
    BOOL sel = shouldSelect();
    if (nav.arrSelectedModels.count < configuration.maxSelectCount && sel && !self.selectPhotoType) {
        model.selected = sel;
        [nav.arrSelectedModels addObject:model];
        
    }
    
    self.albumListModel = [ZLPhotoManager getCameraRollAlbumList:configuration.allowSelectVideo allowSelectImage:configuration.allowSelectImage];
    [self.collectionView reloadData];
    [self scrollToBottom];
    [self resetBottomBtnsStatus:NO];
}

- (void)getOriginalImageBytes
{
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    zl_weakify(self);
    [ZLPhotoManager getPhotosBytesWithArray:nav.arrSelectedModels completion:^(NSString *photosBytes) {
        zl_strongify(weakSelf);
        strongSelf.labPhotosBytes.text = [NSString stringWithFormat:@"(%@)", photosBytes];
    }];
}

#pragma mark - UIViewControllerPreviewingDelegate
//!!!!: 3D Touch
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    if (!indexPath) {
        return nil;
    }
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ZLTakePhotoCell class]]) {
        return nil;
    }
    
    //设置突出区域
    previewingContext.sourceRect = [self.collectionView cellForItemAtIndexPath:indexPath].frame;
    
    ZLForceTouchPreviewController *vc = [[ZLForceTouchPreviewController alloc] init];
    
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    
    NSInteger index = indexPath.row;
    if (self.allowTakePhoto && !configuration.sortAscending) {
        index = indexPath.row - 1;
    }
    ZLPhotoModel *model = self.arrDataSources[index];
    vc.model = model;
    vc.allowSelectGif = configuration.allowSelectGif;
    vc.allowSelectLivePhoto = configuration.allowSelectLivePhoto;
    
    vc.preferredContentSize = [self getSize:model];
    
    return vc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    ZLPhotoModel *model = [(ZLForceTouchPreviewController *)viewControllerToCommit model];
    
    UIViewController *vc = [self getMatchVCWithModel:model];
    if (vc) {
        [self showViewController:vc sender:self];
    }
}

- (CGSize)getSize:(ZLPhotoModel *)model
{
    CGFloat w = MIN(model.asset.pixelWidth, kViewWidth);
    CGFloat h = w * model.asset.pixelHeight / model.asset.pixelWidth;
    if (isnan(h)) return CGSizeZero;
    
    if (h > kViewHeight || isnan(h)) {
        h = kViewHeight;
        w = h * model.asset.pixelWidth / model.asset.pixelHeight;
    }
    
    return CGSizeMake(w, h);
}

@end

