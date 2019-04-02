//
//  DQKSectionViewCell.h
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//  左边一列内容

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DQKSectionViewCellStyle) {
    DQKSectionViewCellStyleDefault,
    DQKSectionViewCellStyleCustom
};

typedef NS_ENUM(NSInteger, DQKSectionViewCellSeparatorStyle) {
    DQKSectionViewCellSeparatorStyleSingleLine,
    DQKSectionViewCellSeparatorStyleNone
};

@protocol DQKSectionViewCellDelegate <NSObject>

@optional
// Called after the user changes the selection.
- (void)touchSection:(id)cell;

@end

@interface DQKSectionViewCell : UIButton

- (instancetype)initWithStyle:(DQKSectionViewCellStyle) style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, weak) id<DQKSectionViewCellDelegate>cellDelegate;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (readonly, assign, nonatomic) DQKSectionViewCellStyle style;
@property (assign, nonatomic) DQKSectionViewCellSeparatorStyle separatorStyle;
@property (strong, nonatomic) NSString *title;

@property (nonatomic, strong) UIImage *downIcon;   

@property NSInteger sectionTip;
@property id msg;

- (void)setTitleColor:(UIColor *)col;
- (void)setLineGoodsDetailType;

@end
