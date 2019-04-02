//
//  NewControls.m
//  fangchou
//
//  Created by guang on 15/5/28.
//  Copyright (c) 2015年 fangchou. All rights reserved.
//

#import "NewControls.h"
#import "GeneralConfig.h"

@implementation NewControls

+ (UIView *)createViewWithFrame:(CGRect)rect backgroundColor:(UIColor *)bgColor
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = bgColor?:[UIColor clearColor];
    return view;
}

+ (UIButton *)createButtonWithFrame:(CGRect)rect normalTitle:(NSString *)normalTitle highlightedTitle:(NSString *)highlightedTitle selectedTitle:(NSString *)selectedTitle normalTitleColor:(UIColor *)normalTitleColor highlightedTitleColor:(UIColor *)highlightedColor selectedColor:(UIColor *)selectedColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)bgColor normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage selectedImage:(UIImage *)selectedImage normalBackgroundImage:(UIImage *)normalBgImage highlightedBgImage:(UIImage *)highlightedBgImage selectedBgImage:(UIImage *)selectedBgImage
{


   // UIButton *button = [[UIButton alloc] initWithFrame:rect];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = rect;
    [button setTitle:normalTitle forState:UIControlStateNormal];
    [button setTitle:highlightedTitle forState:UIControlStateHighlighted];
    [button setTitle:selectedTitle forState:UIControlStateSelected];
    [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    button.titleLabel.font = titleFont;
    button.backgroundColor = bgColor?:[UIColor clearColor];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setBackgroundImage:normalBgImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedBgImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:selectedBgImage forState:UIControlStateSelected];
    return button;
}

+ (UILabel *)createLabelWithFrame:(CGRect)rect text:(NSString *)labelText font:(UIFont *)labelFont textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAignment backgroundColor:(UIColor *)bgColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = labelText;
    label.font = labelFont;
    label.textColor = textColor;
    label.textAlignment = textAignment;
    label.backgroundColor = bgColor?:[UIColor clearColor];
    return label;
}

+ (UIImageView *)createImageViewWithFrame:(CGRect)rect image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = image;
    return imageView;
}

+ (UITextField *)createTextFieldWithFrame:(CGRect)rect placeholder:(NSString *)placeholder textColor:(UIColor *)textColor textFont:(UIFont *)textFont textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor *)bgColor returnKeyType:(UIReturnKeyType)returnKeyType
{
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    textField.textAlignment = textAlignment;
    textField.placeholder = placeholder;
    textField.textColor = textColor;
    textField.font = textFont;
    textField.backgroundColor = bgColor?:[UIColor clearColor];
    textField.returnKeyType = returnKeyType;
    textField.tintColor = kUIColorFromRGB(0xFF675E);
    return textField;
}

+ (M80AttributedLabel*)createAttributedLabelWithFrame:(CGRect)rect
                                             fontArray:(NSArray*)fontSizes
                                            textArray:(NSArray*)textArray
                                           colorArray:(NSArray*)colorArray
                                        numberOfLines:(NSInteger)numberOfLines
                                       backgroudColor:(UIColor*)backgroudColor
{

    M80AttributedLabel *attributedLabel = [[M80AttributedLabel alloc] initWithFrame:rect];
    NSInteger count = [textArray count];
    for (NSInteger i=0;i<count;i++)
    {
        UIColor *textColor =  colorArray[i];
        NSString *text = textArray[i];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:text];
        if (fontSizes.count == 1)
        {
            [attributedText setFont:fontSizes[0]];
        }
        else
        {
            [attributedText setFont:fontSizes[i]];
        }
        
        [attributedText setTextColor:textColor];
        [attributedLabel appendAttributedText:attributedText];
    }
    attributedLabel.numberOfLines = numberOfLines;
    attributedLabel.backgroundColor = backgroudColor?:[UIColor clearColor];
    return attributedLabel;

}



@end
