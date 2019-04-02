//
//  PhotoSelectController.h
//  Expecta
//
//  Created by zhang yyuan on 2018/7/5.
//

#import <IOSKit/GeneralViewController.h>
#import <IOSKit/IOSKit.h>
#import "ZLPhotoModel.h"
@class ZLAlbumListModel;

@interface PhotoSelectController : GeneralViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *btnPreView;
@property (nonatomic, strong) UIButton *btnOriginalPhoto;
@property (nonatomic, strong) UILabel *labPhotosBytes;
@property (nonatomic, strong) UIButton *btnDone;

//相册model
@property (nonatomic, strong) ZLAlbumListModel *albumListModel;

// 区分单选还是多选  默认多选
@property (nonatomic, assign) PhotoSelectType selectPhotoType;

// 从外部调用 刷新列表
- (void)reloadCollectionViewFrowOutSideWithAddModel:(ZLPhotoModel *)model;

// 从外部调用 重新加载列表
- (void)reloadCollectionViewFrowOutSide;

@end

