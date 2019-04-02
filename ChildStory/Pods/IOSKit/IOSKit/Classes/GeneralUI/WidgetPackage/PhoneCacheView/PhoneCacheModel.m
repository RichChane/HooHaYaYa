//
//  PhoneCacheModel.m
//  kpkd
//
//  Created by gzkp on 2017/7/18.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "PhoneCacheModel.h"

@implementation PhoneCacheModel

+ (NSArray*)createPhoneCacheModelArr
{
    NSMutableArray *phoneCacheArr = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i < 10; i ++) {
        PhoneCacheModel *model = [[PhoneCacheModel alloc]init];
        model.userName = @"Rich";
        model.userPhone = [NSString stringWithFormat:@"15017523840%d",i];
        model.userPassword = @"1234567";
        
        [phoneCacheArr addObject:model];
    }
    
    return phoneCacheArr;
}






@end
