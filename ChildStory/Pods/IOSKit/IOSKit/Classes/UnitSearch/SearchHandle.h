//
//  SearchHandle.h
//  kp
//
//  Created by zhang yyuan on 2017/6/12.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchHandleDelegate <NSObject>

//必须实现
@required

/**
 准备就绪
 
 */
- (void)searchReady;


/**
 回调结果
 
 @param text 结果
 */
- (void)searchText:(NSString *)text;

/**
 结束
 
 */
- (void)searchEnd;

@optional

/// 实时的搜索框里的文字
- (void)searchHandText:(NSString *)syncText;

// 点击搜索栏左边按钮
- (void)searchHandLeftAction:(id)searchHandSelf;

@end


@interface SearchHandle : UITextField<UITextFieldDelegate>{
    NSString *searchText;
    
    __weak id<SearchHandleDelegate> searchDelegate;
    
    NSTimer *timer;
    
    BOOL unEdit;
    BOOL inEditText;            // 是否在输入中
    
    NSString *searchTip;
}

@property BOOL returnEndSearch;         // 只响应搜索按钮

@property(strong, nonatomic) UIColor *SC;         // 目前用于搜索框背景
@property(strong, nonatomic) UIImage *SCImage;         // 搜索框logo
@property(strong, nonatomic) UIImage *SCImageClose;         // 搜索框 删除图标
@property CGFloat SCF;         // 搜索框 字体大小

- (instancetype)initWithFrame:(CGRect)frame Tip:(NSString *)tip Delegate:(id<SearchHandleDelegate>)delegate;


- (void)setToSearchText:(NSString *)text;

- (void)setLeftViewTip:(UIView *)view;

// 点击筛选是搜索  不要等点击搜索才搜索
- (void)startSearch;

@end
