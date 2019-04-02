//
//  UIView+KeyBoardManager.h
//  kp
//
//  Created by gzkp on 2017/6/12.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ScrollViewNormal,
    ScrollViewTable,
  
} ScrollType;

@interface UIView (KeyBoardManager)

- (void)addKeyBoardNotice;

- (void)removeKeyBoardObserver;

- (void)setScrollType:(ScrollType)scrollType;

- (void)setOriginFrame:(CGRect)originFrame;

- (void)setScrollType:(ScrollType)scrollType originFrame:(CGRect)originFrame;

- (void)setAdditionalHeight:(CGFloat)additionalHeight;

- (void)setTextFieldCollection:(NSArray*)textFieldCollection;



@end
