//
//  SegmentButton.h
//  kpkd
//
//  Created by gzkp on 2017/12/21.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentButton : UIButton

@property (nonatomic,strong) UILabel *textLabel;

- (id)initLeftRightWithFrame:(CGRect)frame image:(UIImage *)image text:(NSString *)text;

- (void)setImageShow:(BOOL)isShow;

@end
