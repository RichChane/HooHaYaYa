//
//  PhoneCacheModel.h
//  kpkd
//
//  Created by gzkp on 2017/7/18.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneCacheModel : NSObject <NSCoding>

@property (nonatomic,strong) NSString *userHeaderUrl;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) NSString *userPassword;


+ (NSArray*)createPhoneCacheModelArr;

@end
