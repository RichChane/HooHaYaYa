//
//  StringCheckout.m
//  kp
//
//  Created by gzkp on 2017/7/6.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "StringCheckout.h"

@implementation StringCheckout

#pragma mark - 字符是否有意义

+ (BOOL) validateString:(NSString*)str
{
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (str && ![str isEqualToString:@""] ) {
        return YES;
    }
    
    return NO;
}


#pragma mark - 邮箱校验

+ (BOOL) validateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

#pragma mark - 手机号码验证

+ (BOOL) validateMobile:(NSString *)mobile//因为存在国外手机号 这个方法不合用

{
    
    //手机号以13， 15，18开头，八个 \d 数字字符
    
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
    
}

#pragma mark - 座机号码验证

+ (BOOL) validateTelphone:(NSString *)telphone

{
    
    NSString *phoneRegex = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:telphone];
    
}

#pragma mark - URL验证

+ (BOOL) validateUrl:(NSString *)url

{
    
    NSString *regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:url];
    
}

#pragma mark - 邮编验证

+ (BOOL) validateZipCode:(NSString *)zipCode

{
    
    NSString *regex = @"[0-9]\\d{5}(?!\\d)";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:zipCode];
    
}

#pragma mark - 金额限制

+ (BOOL)validateValue:(NSString *)value Flost:(NSInteger)flost Negative:(BOOL)isEnable
{
    NSString *vRegex = nil;
    if (flost > 0) {
        if (isEnable) {
            vRegex = [NSString stringWithFormat:@"(^[-1-9][0-9]*(\\.[0-9]{0,%d})?$)|(^0(\\.[0-9]{0,%d})?)$" ,flost ,flost];
        } else {
            vRegex = [NSString stringWithFormat:@"(^[1-9][0-9]*(\\.[0-9]{0,%d})?$)|(^0(\\.[0-9]{0,%d})?)$" ,flost ,flost];
        }
    } else {
        if (isEnable) {
            vRegex = @"(^[-1-9][0-9]*)";
        } else {
            vRegex = @"(^[1-9][0-9]*)";
        }
    }
    if (vRegex) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",vRegex];
        return [predicate evaluateWithObject:value];
    }
    return YES;
}
//+ (BOOL)validateMoney_2:(NSString *)money
//{
//    NSString *phoneRegex = @"(^[1-9][0-9]*(\\.[0-9]{0,2})?$)|(^0(\\.[0-9]{0,2})?)$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:money];
//}

#pragma mark - 限制数字
+ (BOOL)validateStringIsNum:(NSString *)str{
    //    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    //    NSRange range = [str rangeOfCharacterFromSet:tmpSet];
    //
    //    if (range.length == 0) {
    //
    //        return NO;
    //    }else{
    //
    //        return YES;
    //    }
    
    //判断整形
    NSScanner* scan = [NSScanner scannerWithString:str];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)validateNumber:(NSString*)number text:(NSString *)textFieldText floatCount:(int64_t)floatCount {
    
    if ([number isEqualToString:@"-"] && textFieldText.length == 0) {//允许输入负数
        return YES;
    }
    
    
    BOOL res = YES;
    
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    int i = 0;
    
    if (number.length==0) {
        
        //允许删除
        
        return  YES;
        
    }
    
    while (i < number.length) {
        
        //确保是数字
        
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        
        if (range.length == 0) {
            
            res = NO;
            
            break;
            
        }
        
        i++;
        
    }
    
    if (textFieldText.length==0) {
        
        //第一个不能是0和.
        
        if ([number isEqualToString:@"."]) {
            
            return NO;
            
        }
        
    }
    
    NSArray *array = [textFieldText componentsSeparatedByString:@"."];
    
    NSInteger count = [array count] ;
    
    //小数点只能有一个
    
    if (count>1&&[number isEqualToString:@"."]) {
        
        return NO;
        
    }
    
    //控制小数点后面的字数
    
    if ([textFieldText rangeOfString:@"."].location!=NSNotFound) {
        
        if (textFieldText.length-[textFieldText rangeOfString:@"."].location>floatCount) {
            
            return NO;
            
        }
        
    }
    
    //控制最大位数
    NSString *intNumber = [array firstObject];
    if (intNumber.length > 20) {
        return NO;
    }
    
    return res;
    
}


@end
