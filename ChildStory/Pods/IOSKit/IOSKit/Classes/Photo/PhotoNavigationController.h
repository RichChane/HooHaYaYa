//
//  PhotoNavigationController.h
//  Expecta
//
//  Created by zhang yyuan on 2018/7/5.
//

#import <IOSKit/GeneralNavigationController.h>

#import <Photos/Photos.h>
#import <IOSKit/ZLPhotoModel.h>

@interface PhotoNavigationController : GeneralNavigationController

@property (nonatomic, copy) NSMutableArray *arrSelectedModels;

/**
 点击确定选择照片回调
 */
@property (nonatomic, copy) void (^callSelectImageBlock)(void);

/**
 编辑图片后回调
 */
@property (nonatomic, copy) void (^callSelectClipImageBlock)(UIImage *, PHAsset *);

/**
 编辑视频后回调
 */
@property (nonatomic, copy) void (^callSelectVideoBlock)(id);

/**
 取消block
 */
@property (nonatomic, copy) void (^cancelBlock)(void);

- (instancetype)initConfiguration:(id)conf Root:(id)rvc;

- (id)getConfiguration;

@end
