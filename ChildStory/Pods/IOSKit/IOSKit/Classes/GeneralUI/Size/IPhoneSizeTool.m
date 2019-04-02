//
//  IPhoneSizeTool.m
//  Randomer
//
//  Created by 王子轩 on 16/4/9.
//  Copyright © 2016年 com.wzx. All rights reserved.
//

#import "IPhoneSizeTool.h"
#import "GeneralConfig.h"

@implementation IPhoneSizeTool
+ (CGRect)RectWithiPhone6p:(CGRect)iphone6p iPhone6:(CGRect)iphone6 iPhone5:(CGRect)iphone5 iPhone4:(CGRect)iphone4 {
    if (SCREEN_HEIGHT==480&&SCREEN_WIDTH==320){
        return iphone4;
    }
    else if(SCREEN_HEIGHT==568&&SCREEN_WIDTH==320){
        return iphone5;
    }
    else if(SCREEN_HEIGHT==667&&SCREEN_WIDTH==375){
        return iphone6;
    }
    else if(SCREEN_HEIGHT==736&&SCREEN_WIDTH==414){
        return iphone6p;
    }else{
        return iphone6p;
    }
}

+ (CGFloat)FloatWithiPhone6p:(CGFloat)iphone6p iPhone6:(CGFloat)iphone6 iPhone5:(CGFloat)iphone5 iPhone4:(CGFloat)iphone4 {
    if (SCREEN_HEIGHT==480&&SCREEN_WIDTH==320){
        return iphone4;
    }
    else if(SCREEN_HEIGHT==568&&SCREEN_WIDTH==320){
        return iphone5;
    }
    else if(SCREEN_HEIGHT==667&&SCREEN_WIDTH==375){
        return iphone6;
    }
    else if(SCREEN_HEIGHT==736&&SCREEN_WIDTH==414){
        return iphone6p;
    }else{
        return iphone6p;
    }
}

+ (CGSize)SizeWithiPhone6p:(CGSize)iphone6p iPhone6:(CGSize)iphone6 iPhone5:(CGSize)iphone5 iPhone4:(CGSize)iphone4 {
    if (SCREEN_HEIGHT==480&&SCREEN_WIDTH==320){
        return iphone4;
    }
    else if(SCREEN_HEIGHT==568&&SCREEN_WIDTH==320){
        return iphone5;
    }
    else if(SCREEN_HEIGHT==667&&SCREEN_WIDTH==375){
        return iphone6;
    }
    else if(SCREEN_HEIGHT==736&&SCREEN_WIDTH==414){
        return iphone6p;
    }else{
        return iphone6p;
    }
}

+ (CGPoint)PointWithiPhone6p:(CGPoint)iphone6p iPhone6:(CGPoint)iphone6 iPhone5:(CGPoint)iphone5 iPhone4:(CGPoint)iphone4 {
    if (SCREEN_HEIGHT==480&&SCREEN_WIDTH==320){
        return iphone4;
    }
    else if(SCREEN_HEIGHT==568&&SCREEN_WIDTH==320){
        return iphone5;
    }
    else if(SCREEN_HEIGHT==667&&SCREEN_WIDTH==375){
        return iphone6;
    }
    else if(SCREEN_HEIGHT==736&&SCREEN_WIDTH==414){
        return iphone6p;
    }else{
        return iphone6p;
    }
}

+ (BOOL)greaterThan:(Version)version {
    return version < [self tureVersion];
}

+ (BOOL)lessThan:(Version)version {
    return version > [self tureVersion];
}

+ (BOOL)equel:(Version)version {
    return version == [self tureVersion];
}

+ (Version)tureVersion {
    if (SCREEN_HEIGHT==480&&SCREEN_WIDTH==320){
        return VersioniPhone4;
    }
    else if(SCREEN_HEIGHT==568&&SCREEN_WIDTH==320){
        return VersioniPhone5;
    }
    else if(SCREEN_HEIGHT==667&&SCREEN_WIDTH==375){
        return VersioniPhone6;
    }
    else if(SCREEN_HEIGHT==736&&SCREEN_WIDTH==414){
        return VersioniPhone6p;
    }else{
        return VersioniPhone6p;
    }
}
@end
