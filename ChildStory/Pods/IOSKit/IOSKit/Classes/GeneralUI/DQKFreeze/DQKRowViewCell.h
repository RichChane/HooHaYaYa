//
//  DQKRowViewCell.h
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//   上边一行内容

#import <UIKit/UIKit.h>

#import <IOSKit/KPTextField.h>

typedef NS_ENUM(NSInteger, DQKRowViewCellSeparatorStyle) {
    DQKRowViewCellSeparatorStyleSingleLine,
    DQKRowViewCellSeparatorStyleNone
};

@protocol DQKRowViewCellDelegate <NSObject>

@optional
// Called after the user changes the selection.
- (void)touchRow:(id)cell;

- (void)changerToRowBack:(id)cell;

@end

@interface DQKRowViewCell : UIButton

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier Edit:(BOOL)isEdit;

@property (nonatomic, weak) id<DQKRowViewCellDelegate>cellDelegate;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) DQKRowViewCellSeparatorStyle separatorStyle;

@property (strong, nonatomic, readonly) KPTextField *titleRowField;
@property (strong, nonatomic, readonly) UILabel *titleRowLab;

@property CGFloat moveTitleSize;            // titleRowField 偏移位置
@property NSInteger moveTitleType;          // -1 左对齐， 0 居中， 1 右对齐

@property (nonatomic, strong) UIImage *rightIcon;           

@property NSInteger rowTip;
@property id msg;

- (void)setUpDownLine:(BOOL)isShowLine;

- (void)setTitleColor:(UIColor *)col;
- (void)setLineGoodsDetailType;

@end
