//
//  UIScrollView+KeyBoardManager.h
//  PreciousMetal
//
//  Created by DemoLi on 16/9/19.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (KeyBoardManager)

- (void)addKeyBoardNotice;

- (void)removeKeyBoardObserver;

- (void)recordItemMaxYForKeyBoard;

- (void)setNeedRecordItemHeight:(CGFloat)itemHeight;

@end
