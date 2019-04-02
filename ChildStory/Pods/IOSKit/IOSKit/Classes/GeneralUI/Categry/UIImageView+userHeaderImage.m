//
//  UIImageView+userHeaderImage.m
//  kp
//
//  Created by Kevin on 2018/3/27.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "UIImageView+userHeaderImage.h"
#import <IOSKit/IOSKit.h>
#import <KPFoundation/KPFoundation.h>
#import "UIImageView+WebCache.h"

@implementation UIImageView(userHeaderImage)

- (void)setImageURL:(NSString *)url userName:(NSString *)userName backgroundColor:(UIColor *)backgroundColor
{
    UILabel * label = [self viewWithTag:199];
    [[self viewWithTag:199] setHidden:YES];
    if(url.length){
        WeakSelf;
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"personal_center_user"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image){
                weakSelf.image = image;
            }else{
                [weakSelf setImageURL:nil userName:userName];
            }
        }];
    }else{
        if(userName.length<=0){
            self.image = [UIImage imageNamed:@"personal_center_user"];
        }else{
            self.backgroundColor = backgroundColor;
            self.image = nil;
            if(!label){
                label = [UIFactory createLabelWithText:@"" textColor:[UIColor whiteColor] font:FontSize(15)];
                label.width = self.width;
                label.height = self.height;
                label.center = CGPointMake(self.width/2, self.height/2);
                label.textAlignment = NSTextAlignmentCenter;
                [self addSubview:label];
                label.tag = 199;
            }
            label.attributedText = [self abbreviationName:userName];
            label.hidden = NO;
        }
    }
    
    
}

- (void)setImageURL:(NSString *)url userName:(NSString *)userName
{
    [self setImageURL:url userName:userName backgroundColor:kUIColorFromRGB(0xD4D4D4)];
}

- (NSAttributedString *)abbreviationName:(NSString *)name
{
    NSMutableString * nameString = name.mutableCopy;
    [nameString replaceOccurrencesOfString:@" "  withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, nameString.length)];
    [nameString replaceOccurrencesOfString:@"\n"  withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, nameString.length)];
    NSString * abbreviationName = nil;
    UIFont * font = nil;
    for(int i=0; i< [nameString length];i++){
        int a = [nameString characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)//有中文
        {
            abbreviationName = [nameString substringFromIndex:nameString.length-MIN(2, nameString.length)];
            font = [UIFont systemFontOfSize:self.width/3];
            break;
        }
    }
    if(!abbreviationName){
        abbreviationName = [nameString substringWithRange:NSMakeRange(0, MIN(2, nameString.length))];
        NSString *regex = @"[A-Z]";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        for(int i=0;i<abbreviationName.length;i++){
            if([pred evaluateWithObject:[abbreviationName substringWithRange:NSMakeRange(i, 1)]]){//有大写
                font = [UIFont systemFontOfSize:self.width/3];
                break;
            }
        }
        if(!font){
            font = [UIFont systemFontOfSize:self.width/2];
        }
    }
    
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:abbreviationName attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return string;
}

@end

