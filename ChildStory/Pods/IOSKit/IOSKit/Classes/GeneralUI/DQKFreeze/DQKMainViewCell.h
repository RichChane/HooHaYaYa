//
//  DQKMainViewCell.h
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//      body 内容，除去左边一列、上边一行

#import <UIKit/UIKit.h>

#import <IOSKit/KPTextField.h>

typedef NS_ENUM(NSInteger, DQKMainViewCellStyle) {
    DQKMainViewCellStyleDefault,
    DQKMainViewCellStyleCustom,
    DQKMainViewCellStyleSingle
};

typedef NS_ENUM(NSInteger, DQKMainViewCellSeparatorStyle) {
    DQKMainViewCellSeparatorStyleSingleLine,
    DQKMainViewCellSeparatorStyleNone
};


@protocol DQKMainViewCellDelegate <NSObject>

@optional
// Called after the user changes the selection.
- (BOOL)willBeginDo:(id)cell;
- (void)changerBeginDo:(id)cell;

- (void)changerToBack:(id)cell;

#pragma mark - TextFieldDelegate
-(BOOL)mainCell:(id)mainCell textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (void)rightActionClickMainCell:(id)mainCell;

@end


typedef void(^EditCallBack)(NSString *cellText);

@interface DQKMainViewCell : UIView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, weak) id<DQKMainViewCellDelegate>cellDelegate;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (readonly, assign, nonatomic) DQKMainViewCellStyle style;
@property (assign, nonatomic) DQKMainViewCellSeparatorStyle separatorStyle;
@property (strong, nonatomic) KPTextField *titleTextField;

@property NSInteger rowNumber;
@property NSInteger sectionNumber;
@property BOOL isTextEditable;
@property BOOL isSingle;

@property NSInteger toRow;
@property NSInteger toSection;


@property (nonatomic,copy) EditCallBack callBack;

- (instancetype)initWithStyle:(DQKMainViewCellStyle) style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)buildPlaceholder:(NSString *)p;

- (void)setSelectedColor:(UIColor *)col;
- (void)setNormalColor:(UIColor *)col;

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder;

+ (nonnull instancetype)appearance;

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait;

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ...;

+ (nonnull instancetype)appearanceWhenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ...;

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection;

- (CGPoint)convertPoint:(CGPoint)point fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (CGRect)convertRect:(CGRect)rect fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (CGRect)convertRect:(CGRect)rect toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator;

- (void)setNeedsFocusUpdate;

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context;

- (void)updateFocusIfNeeded;

@end
