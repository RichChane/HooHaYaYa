//
//  UIImageView+userHeaderImage.h
//  kp
//
//  Created by Kevin on 2018/3/27.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView(userHeaderImage)

- (void)setImageURL:(NSString *)url userName:(NSString *)userName backgroundColor:(UIColor *)backgroundColor;
- (void)setImageURL:(NSString *)url userName:(NSString *)userName;

@end
