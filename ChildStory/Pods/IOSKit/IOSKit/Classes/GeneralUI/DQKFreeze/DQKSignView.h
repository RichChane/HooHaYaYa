//
//  DQKFreezeView.h
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/15.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQKSignView : UIButton

@property (strong, nonatomic) NSString *content;

@property CGFloat moveSignSize;            // titleRowField 偏移位置
@property NSInteger moveSignType;          // -1 左对齐， 0 居中， 1 右对齐

@property (nonatomic, strong) UIImage *rightIcon;

- (void)setTitleColor:(UIColor *)col;

- (void)upToLoad;

@end
