//
//  BookStoreSegmentView.h
//  仿搜狗阅读
//
//  Created by DemoLi on 2017/2/15.
//  Copyright © 2017年 YinTokey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookStoreSegmentViewDelegete;
typedef void (^SelectTitleActin)(NSInteger tag);

@interface BookStoreSegmentView : UIView

@property (nonatomic,copy) SelectTitleActin selectTitle;
@property (nonatomic,weak) id<BookStoreSegmentViewDelegete> delegate;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSInteger tempSelectedIndex;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,assign) BOOL hasPoint;

@property (nonatomic,assign) BOOL unVernier;            // 是否 不需要游标

@property (nonatomic, strong) UIImage *pointImage;      // [UIImage imageNamed:@"tablepoint"]

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray*)titleArr;

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray*)titleArr hasPoint:(BOOL)hasPoint NeedVernier:(BOOL)isNeed PointImage:(UIImage *)pImg IsMustThree:(BOOL)isMustThree;

- (void)setSelectedIndex:(NSInteger)aSelectedIndex;

- (void)setBaseStatus:(UIColor *)selectTitleColor normalTitleColor:(UIColor *)normalTitleColor backgroundColor:(UIColor *)backgroundColor;

- (void)setCurrentMarkShow:(BOOL)isShow Which:(NSInteger)index_;

- (void)refreshViewWith:(NSArray *)titleArr selectIndex:(NSInteger)selectIndex;

@end

@protocol BookStoreSegmentViewDelegete <NSObject>

- (void)segmentView:(id)segmentView selectTitleIndex:(NSInteger)tag;

@end
