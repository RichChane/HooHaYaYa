//
//  DQKData.m
//  kpkd
//
//  Created by zhang yyuan on 2017/8/2.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "DQKData.h"

@implementation DQKData

- (instancetype)init
{
    self = [super init];
    if (self) {
        insertMsg = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)insertObject:(NSString *)object inSegment:(NSInteger)segmentIndex row:(NSInteger)row section:(NSInteger)section {
    if (object) {
        insertMsg[[NSString stringWithFormat:@"%ld_%ld-%ld" ,segmentIndex ,row ,section]] = object;
    }else{
        if (insertMsg[[NSString stringWithFormat:@"%ld_%ld-%ld" ,segmentIndex ,row ,section]]) {
            [insertMsg removeObjectForKey:[NSString stringWithFormat:@"%ld_%ld-%ld" ,segmentIndex ,row ,section]];
        }
    }
}

- (void)addOneObject:(NSString *)object inSegment:(NSInteger)segmentIndex row:(NSInteger)row section:(NSInteger)section {
    if (object) {
        NSString *theOne = insertMsg[[NSString stringWithFormat:@"%ld_%ld-%ld" ,segmentIndex ,row ,section]];
        insertMsg[[NSString stringWithFormat:@"%ld_%ld-%ld" ,segmentIndex ,row ,section]] = [NSString stringWithFormat:@"%lf" ,object.doubleValue + theOne.doubleValue];
    }
}

- (NSString *)getObjectInSegment:(NSInteger)segmentIndex row:(NSInteger)row section:(NSInteger)section {
    if (segmentIndex >= 0) {
        if (row >= 0 && section >= 0) {
            return insertMsg[[NSString stringWithFormat:@"%ld_%ld-%ld" ,segmentIndex ,row ,section]];
        }else{
            
            double value = 0;
            
            NSArray *allKeys = [insertMsg allKeys];
            for (NSInteger i = 0; allKeys && i < [allKeys count]; i++) {
                if (row < 0 && section >= 0){
                    
                    if ([allKeys[i] containsString:[NSString stringWithFormat:@"%ld_" ,segmentIndex]] && [allKeys[i] containsString:[NSString stringWithFormat:@"-%ld" ,section]]) {
                        value += ((NSString *)insertMsg[allKeys[i]]).doubleValue;
                    }
                    
                }else if (row >= 0 && section < 0){
                    
                    if ([allKeys[i] containsString:[NSString stringWithFormat:@"%ld_" ,segmentIndex]] && [allKeys[i] containsString:[NSString stringWithFormat:@"_%ld-" ,row]]) {
                        value += ((NSString *)insertMsg[allKeys[i]]).doubleValue;
                    }
                    
                }else if (row < 0 && section < 0){
                    
                    if ([allKeys[i] containsString:[NSString stringWithFormat:@"%ld_" ,segmentIndex]]) {
                        value += ((NSString *)insertMsg[allKeys[i]]).doubleValue;
                    }
                    
                }
            }
            
            if (value != 0) {
                return [NSString stringWithFormat:@"%lf" ,value];
            }
        }
    }
    
    return nil;
}

- (void)cleanSegmentIndex:(NSInteger)segmentIndex{
    NSString *segStr = [NSString stringWithFormat:@"%ld_" ,segmentIndex];
    NSArray *allKeys = [insertMsg allKeys];
    for (NSInteger i = 0; allKeys && i < [allKeys count]; i++) {
        if ([allKeys[i] containsString:segStr]) {
            [insertMsg removeObjectForKey:allKeys[i]];
        }
    }
}

- (void)cleanAll{
    [insertMsg removeAllObjects];
}

@end
