//
//  DQKData.h
//  kpkd
//
//  Created by zhang yyuan on 2017/8/2.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQKData : NSObject{
    NSMutableDictionary *insertMsg;
}


/**
 设置数据

 @param object 值
 @param segmentIndex 维度 >= 0
 @param row 维度
 @param section 维度
 */
- (void)insertObject:(NSString *)object inSegment:(NSInteger)segmentIndex row:(NSInteger)row section:(NSInteger)section;
- (void)addOneObject:(NSString *)object inSegment:(NSInteger)segmentIndex row:(NSInteger)row section:(NSInteger)section;        // 会叠加

/**
 获取数据

 @param segmentIndex 维度 >= 0
 @param row 维度 -1表示，全部维度
 @param section 维度 -1表示，全部维度
 @return 返回结果
 */
- (NSString *)getObjectInSegment:(NSInteger)segmentIndex row:(NSInteger)row section:(NSInteger)section;

- (void)cleanSegmentIndex:(NSInteger)segmentIndex;
- (void)cleanAll;


@end
