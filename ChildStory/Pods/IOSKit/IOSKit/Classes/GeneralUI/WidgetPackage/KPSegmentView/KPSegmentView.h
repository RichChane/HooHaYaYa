//
//  KPSegmentView.h
//  kpkdpad
//
//  Created by lkr on 2018/5/2.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KPSegViewBlock)(NSInteger index);

/// 选择框 至少2个选择
@interface KPSegmentView : UIView

/// 选中的位置 默认是0
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) KPSegViewBlock segBlock;

- (id)initWithFrame:(CGRect)frame AndSegmentArray:(NSArray *)segArray;

@end
