//
//  LeveyTabBar.h
//  LeveyTabBarController
//
//  Created by zhang on 12-10-10.
//  Copyright (c) 2012年 jclt. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <IOSKit/TabBarDelegate.h>

#import <IOSKit/NumbTagView.h>

#define MAXNEWPOINT     10

#define TabBarDefault     @"TabBar_Default"
#define TabBarSeleted     @"Seleted_Default"
#define TabBarName     @"Item_Name"

@interface LeveyTabBar : UIView
{
	UIImageView *backgroundView;
	NSMutableArray *_buttons;
    UIView *newPoint[MAXNEWPOINT];
    
    CGFloat showHeight;
    
}
@property (nonatomic, assign) id<TabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;

@property(strong, nonatomic) UIColor *TC;         // 目前用于默认底部bar字体颜色

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray ShowHeight:(CGFloat)sHeight;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)removeTabAtIndex:(NSInteger)index;
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index MaxTag:(NSUInteger)maxTag;
- (void)setBackgroundImage:(UIImage *)img;

- (void)setToNewPoint:(NSInteger)which IsHid:(BOOL)toHid;
- (void)setToNew:(NSInteger)which Numb:(NSString *)numbStr CleanAll:(BOOL)isCleanAll;
- (void)setTitleToNew:(NSInteger)which Title:(NSString *)titleStr ImageNor:(UIImage *)imageNor ImageSelected:(UIImage *)imageSelected;
@end
