//
//  RCMJRefreshHeader.h
//  RCIOS-SDK
//
//  Created by gzkp on 2019/2/23.
//  Copyright © 2019年 RC. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

#define StatusLabelHeight MJRefreshHeaderHeight/2

@interface RCMJRefreshHeader : MJRefreshHeader

#pragma mark - 刷新时间相关
/** 利用这个block来决定显示的更新时间文字 */
@property (copy, nonatomic) NSString *(^lastUpdatedTimeText)(NSDate *lastUpdatedTime);
/** 显示上一次刷新时间的label */
@property (weak, nonatomic, readonly) UILabel *lastUpdatedTimeLabel;

#pragma mark - 状态相关
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;

@end

NS_ASSUME_NONNULL_END
