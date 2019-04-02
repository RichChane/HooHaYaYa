//
//  StringCheckout.h
//  kp
//
//  Created by gzkp on 2017/7/6.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringCheckout : NSObject

#pragma mark - 字符是否有意义
+ (BOOL) validateString:(NSString*)str;

#pragma mark - 邮箱校验
+ (BOOL) validateEmail:(NSString *)email;

#pragma mark - 手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

#pragma mark - 座机号码验证
+ (BOOL) validateTelphone:(NSString *)telphone;

#pragma mark - URL验证
+ (BOOL) validateUrl:(NSString *)url;

#pragma mark - 邮编验证
+ (BOOL) validateZipCode:(NSString *)zipCode;

/**
 判断是否是合法浮点数

 @param value 要判断的值
 @param flost 浮点数
 @param isEnable 是否可以输入负数
 @return 是否合法
 */
+ (BOOL)validateValue:(NSString *)value Flost:(NSInteger)flost Negative:(BOOL)isEnable;

#pragma mark - 限制数字
+ (BOOL)validateStringIsNum:(NSString *)str;

#pragma mark - 校验浮点数字
+ (BOOL)validateNumber:(NSString*)number text:(NSString *)textFieldText floatCount:(int64_t)floatCount;


@end

