//
//  NewControls.h
//  fangchou
//
//  Created by guang on 15/5/28.
//  Copyright (c) 2015年 fangchou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "M80AttributedLabel.h"

@interface NewControls : NSObject

+ (UIView *)createViewWithFrame:(CGRect)rect backgroundColor:(UIColor *)bgColor;

+ (UIButton *)createButtonWithFrame:(CGRect)rect
                        normalTitle:(NSString *)normalTitle
                   highlightedTitle:(NSString *)highlightedTitle
                      selectedTitle:(NSString *)selectedTitle
                   normalTitleColor:(UIColor *)normalTitleColor
              highlightedTitleColor:(UIColor *)highlightedColor
                      selectedColor:(UIColor *)selectedColor
                          titleFont:(UIFont *)titleFont
                    backgroundColor:(UIColor *)bgColor
                        normalImage:(UIImage *)normalImage
                   highlightedImage:(UIImage *)highlightedImage
                      selectedImage:(UIImage *)selectedImage
              normalBackgroundImage:(UIImage *)normalBgImage
                 highlightedBgImage:(UIImage *)highlightedBgImage
                    selectedBgImage:(UIImage *)selectedBgImage;

+ (UILabel *)createLabelWithFrame:(CGRect)rect
                             text:(NSString *)labelText
                             font:(UIFont *)labelFont
                        textColor:(UIColor *)textColor
                    textAlignment:(NSTextAlignment)textAignment
                  backgroundColor:(UIColor *)bgColor;

+ (UIImageView *)createImageViewWithFrame:(CGRect)rect image:(UIImage *)image;

+ (UITextField *)createTextFieldWithFrame:(CGRect)rect
                              placeholder:(NSString *)placeholder
                                textColor:(UIColor *)textColor
                                 textFont:(UIFont *)textFont
                            textAlignment:(NSTextAlignment)textAlignment
                          backgroundColor:(UIColor *)bgColor
                            returnKeyType:(UIReturnKeyType)returnKeyType;

+ (M80AttributedLabel*)createAttributedLabelWithFrame:(CGRect)rect
                                            fontArray:(NSArray*)fontSizes
                                            textArray:(NSArray*)textArray
                                           colorArray:(NSArray*)colorArray
                                        numberOfLines:(NSInteger)numberOfLines
                                       backgroudColor:(UIColor*)backgroudColor;

@end
