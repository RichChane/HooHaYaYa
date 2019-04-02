//
//  UIFactory.m
//  kpkd
//
//  Created by Kevin on 2018/1/11.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import <IOSKit/UIFactory.h>

#import <IOSKit/IOSKit.h>
#import <KPFoundation/KPFoundation.h>

@implementation UIFactory
+ (NSString *)showMoney:(NSString *)moneyString FloatingNumber:(int64_t)fillZero
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    LanguageType languageType = [MultiLanguage Share].languageType;
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    BOOL isEnglish = NO;
    BOOL isHans = YES;
    if (languageType == LanguageTypeSimpleChinese){//中文，包括简体
        isHans = YES;
    }else if (languageType == LanguageTypeTraditionalChinese) {//中文，繁体
        isHans = NO;
    }else{
        isEnglish = YES;
    }
    double num;
    short scale;
    double moneyNum = moneyString.doubleValue;
    BOOL minus = moneyNum<0;
    if(minus){
        moneyNum = -moneyNum;
    }
    NSString * meta;
    NSRoundingMode round = NSRoundDown;
    if(!isEnglish){
        if(moneyNum<100000){
            num = moneyNum;
            scale = fillZero;
            meta = @"";
            round = NSRoundBankers;
        }else if (moneyNum<100000000){
            num = moneyNum/10000.0f;
            scale = 2;
            meta = isHans?@"万":@"萬";
        }else{
            num = moneyNum/100000000.0f;
            scale = 2;
            meta = isHans?@"亿":@"億";
        }
    }else{
        if(moneyNum<10000){
            num = moneyNum;
            scale = fillZero;
            meta = @"";
            round = NSRoundBankers;
        }else if (moneyNum<1000000){
            num = moneyNum/1000.0f;
            scale = 2;
            meta = @"k";
        }else if(moneyNum<1000000000.0f){
            num = moneyNum/1000000.0f;
            scale = 2;
            meta = @"m";
        }else{
            num = moneyNum/1000000000.0f;
            scale = 2;
            meta = @"b";
        }
    }
    
    NSString * numbStr;
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:round
                                       scale:scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    
    NSDecimalNumber *yy = [[NSDecimalNumber decimalNumberWithString:[@(num)stringValue]] decimalNumberByRoundingAccordingToBehavior:roundUp];
    numbStr = yy.stringValue;
    
    numbStr = [GeneralUse StrmethodComma:numbStr FloatingNumber:fillZero];
    
    if(minus){
        numbStr = [@"-"stringByAppendingString:numbStr];
    }
    NSArray *arr1 = [numbStr componentsSeparatedByString:@"."];
    if(arr1.count==2&&[arr1.lastObject integerValue]==0){
        numbStr = arr1.firstObject;
    }
    return [numbStr stringByAppendingFormat:@"%@",meta];
}

+ (CGSize)sizeFromString:(NSString *)string maxWidth:(CGFloat)width maxHeight:(CGFloat)height font:(UIFont *)font lineSpace:(CGFloat)lineSpace
{
    if(!string||!font||!width){
        return CGSizeZero;
    }
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    if(height!=0){
        maxSize.height = height;
    }
    
    CGSize textSize = CGSizeZero;
    
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style};
    
    CGRect rect = [string boundingRectWithSize:maxSize
                                       options:opts
                                    attributes:attributes
                                       context:nil];
    textSize = rect.size;
    return textSize;
}
+ (CGSize)sizeFromString:(NSString *)string maxWidth:(CGFloat)width maxHeight:(CGFloat)height font:(UIFont *)font
{
    return [self sizeFromString:string maxWidth:width maxHeight:height font:font lineSpace:0];
}

+ (UILabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font lineSpace:(CGFloat)lineSpace
{
    return [self createLabelWithText:text textColor:textColor textAlignment:NSTextAlignmentLeft font:font lineSpace:lineSpace maxWidth:SCREEN_WIDTH-30];
}

+ (UILabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment font:(UIFont *)font lineSpace:(CGFloat)lineSpace maxWidth:(CGFloat)width
{
    UILabel *commonLabel = [[UILabel alloc] init];
    commonLabel.backgroundColor = [UIColor clearColor];
    commonLabel.numberOfLines= 0;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    style.alignment = alignment;
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style,NSForegroundColorAttributeName:textColor};
    CGSize stringsize = [self sizeFromString:text maxWidth:width maxHeight:0 font:font lineSpace:lineSpace];
    commonLabel.size = stringsize;
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    commonLabel.attributedText = string;
    return commonLabel;
}

+ (UILabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font
{
    UILabel * label = [UIFactory createLabelWithText:text textColor:textColor font:font maxWidth:[UIScreen mainScreen].bounds.size.width];
    return label;
}

+ (UILabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font maxWidth:(CGFloat)width
{
    UILabel * label = [UIFactory createLabel:width textColor:textColor alignment:NSTextAlignmentLeft font:font lineNum:0];
    CGSize size = [UIFactory sizeFromString:text maxWidth:width maxHeight:0 font:font];
    CGRect rect = label.frame;
    rect.size = CGSizeMake(size.width, size.height?size.height:font.lineHeight);
    label.frame = rect;
    label.text = text;
    return label;
}

+ (UILabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font maxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    UILabel * label = [UIFactory createLabel:width textColor:textColor alignment:NSTextAlignmentLeft font:font lineNum:0];
    CGSize size = [UIFactory sizeFromString:text maxWidth:width maxHeight:height font:font];
    CGRect rect = label.frame;
    rect.size = CGSizeMake(size.width, size.height?size.height:font.lineHeight);
    label.frame = rect;
    label.text = text;
    return label;
}

+ (UILabel *)createLabel:(CGFloat)width textColor:(UIColor *)textColor alignment:(NSTextAlignment)align font:(UIFont *)textFont
{
    return [UIFactory createLabel:width textColor:textColor alignment:align font:textFont lineNum:1];
}

+ (UILabel *)createLabel:(CGFloat)width textColor:(UIColor *)textColor alignment:(NSTextAlignment)align font:(UIFont *)textFont lineNum:(NSInteger)lineNum
{
    UILabel * label = [UIFactory createCommonLabel:CGRectZero textColor:textColor backgroundColor:[UIColor clearColor] textFont:textFont text:@""];
    CGRect rect = label.frame;
    rect.size.width = width;
    rect.size.height = lineNum*textFont.lineHeight;
    label.frame = rect;
    label.numberOfLines = lineNum;
    label.textAlignment = align;
    return label;
}

//创建Label
+ (UILabel *)createCommonLabel:(CGRect)frame textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor textFont:(UIFont *)textFont text:(NSString *)text{
    UILabel *commonLabel = [[UILabel alloc] initWithFrame:frame];
    commonLabel.backgroundColor = backgroundColor;
    commonLabel.text = text;
    commonLabel.font = textFont;
    commonLabel.textColor = textColor;
    commonLabel.textAlignment = NSTextAlignmentLeft;
    return commonLabel;
}

+ (UIButton *)createBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont*)titleFont target:(id)target select:(SEL)function
{
    CGSize titleSize = [self sizeFromString:title maxWidth:SCREEN_WIDTH maxHeight:SCREEN_HEIGHT font:titleFont];
    CGRect rect = CGRectMake(0, 0, titleSize.width, titleSize.height);
    UIButton * btn = [self createbtnWithRect:rect target:target select:function];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = titleFont;
    return btn;
}

+ (UIButton *)createbtnWithRect:(CGRect)frame target:(id)target select:(SEL)function
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:function forControlEvents:UIControlEventTouchUpInside];
    btn.frame = frame;
    return btn;
}

+ (UIButton *)createbtnWithImage:(UIImage *)image target:(id)target select:(SEL)function
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        [btn setImage:image forState:0];
    }
    [btn addTarget:target action:function forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)createbtnWithTitle:(NSString *)title target:(id)target select:(SEL)function{
    
    UIButton * btn = [UIFactory createbtnWithTitle:title BackgroundColoer:GC.MC CornerRadius:ASIZE(4) target:target select:function];
    return btn;
}

+ (UIButton *)createbtnWithTitle:(NSString *)title BackgroundColoer:(UIColor *)backgroundColor CornerRadius:(CGFloat)cornerRadius target:(id)target select:(SEL)function {
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:0];
    if (backgroundColor) {
        [btn setBackgroundColor:backgroundColor];
    }else {
        [btn setBackgroundColor:GC.MC];
    }
    
    if (cornerRadius) {
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = cornerRadius;
    }
    
    [btn addTarget:target action:function forControlEvents:UIControlEventTouchUpInside];
    return btn;
    
}

+ (UIButton *)createWhitebtnWithYellowTitle:(NSString *)title target:(id)target select:(SEL)function{
    
    UIButton * btn = [UIFactory createbtnWithTitle:title TitleColor:GC.MC BackgroundColoer:[UIColor whiteColor] CornerRadius:ASIZE(4) BorderColor:GC.MC BorderWidth:1 target:target select:function];
    return btn;
}

+ (UIButton *)createbtnWithTitle:(NSString *)title TitleColor:(UIColor *)titleColor BackgroundColoer:(UIColor *)backgroundColor CornerRadius:(CGFloat)cornerRadius BorderColor:(UIColor *)borderColor BorderWidth:(CGFloat)borderWidth target:(id)target select:(SEL)function {
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:0];
    if (backgroundColor) {
        [btn setBackgroundColor:backgroundColor];
    }else {
        [btn setBackgroundColor:GC.MC];
    }
    
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    if (cornerRadius) {
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = cornerRadius;
    }
    
    if (borderColor) {
        btn.layer.borderColor = borderColor.CGColor;
        btn.layer.masksToBounds = YES;
    }
    
    if (borderWidth) {
        btn.layer.borderWidth = borderWidth;
        btn.layer.masksToBounds = YES;
    }
    
    [btn addTarget:target action:function forControlEvents:UIControlEventTouchUpInside];
    return btn;
    
}

+ (UIView *)guideViewWith:(NSInteger)count
{
    UIView * view = [[UIView alloc] init];
    if (count == 0) {
        view.frame = CGRectMake(0, 0, ASIZE(10), ASIZE(10));
        view.backgroundColor = GC.MC;
    }else {
        view.frame = CGRectMake(0, 0, 15, 15);
        view.backgroundColor = [UIColor redColor];
        
        NSString * countStr = count>99?@"99+":[NSString stringWithFormat:@"%ld",count];
        
        UILabel * lable = [[UILabel alloc] initWithFrame:view.bounds];
        [lable setText:countStr];
        lable.textColor = [UIColor whiteColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:12];
        CGSize size = [countStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 15)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        if (size.width > 14) {
            view.frame = CGRectMake(0, 0, size.width + 2, 15);
            lable.frame = CGRectMake(0, 0, size.width + 2, 15);
        }
        [view addSubview:lable];
    }
    view.layer.cornerRadius = view.height/2;
    
    return view;
}

+ (UIImageView *)createImageViewWithImageName:(NSString *)imageName
{
    if(!imageName||imageName.length==0){
        return nil;
    }
    UIImageView * imageView = [self createImageViewWithImageName:imageName tinColor:nil];
    return imageView;
}

+ (UIImageView *)createImageViewWithImageName:(NSString *)imageName tinColor:(UIColor *)color
{
    UIImage * image = [UIImage imageNamed:imageName];
    if(color){
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    if(color){
        imageView.tintColor = color;
    }
    return imageView;
}

+ (UIView *)createViewWithImageName:(NSString *)imageName andGuideCount:(NSInteger)count {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    UIImageView * imageView = [UIFactory createImageViewWithImageName:imageName];
    imageView.size = CGSizeMake(20, 20);
    imageView.center = view.center;
    
    UIView * guideView = [UIFactory guideViewWith:count];
    guideView.frame = CGRectMake(CGRectGetWidth(view.frame) - CGRectGetWidth(guideView.frame), 0, CGRectGetWidth(guideView.frame), CGRectGetHeight(guideView.frame));
    
    [view addSubview:imageView];
    [view addSubview:guideView];
    
    return view;
}

+ (UILabel *)createSaveLabel {
    UILabel *label = [UIFactory createLabelWithText:ML(@"保存") Frame:CGRectMake(0, 0, 73, 32) textColor:[UIColor whiteColor] font:FontSize(14) BackGroundColor:GC.MC borderColor:nil];
    return label;
}

+ (UILabel *)createLabelWithText:(NSString *)text Frame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font BackGroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor{
    
    UILabel *lable = [UIFactory createLabelWithText:text textColor:textColor font:font];
    if (frame.size.width) {
        
    }else {
        frame = CGRectMake(0, 0, 73, 32);
    }
    lable.frame = frame;
    lable.backgroundColor = backgroundColor;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.layer.cornerRadius = frame.size.height/2;
    lable.layer.masksToBounds = YES;
    if (borderColor) {
        lable.layer.borderColor = borderColor.CGColor;
        lable.layer.borderWidth = 1;
    }
    return lable;
}

+ (YYTextView*)createAttributedLabelWithFrame:(CGRect)rect
                                    fontArray:(NSArray*)fontSizes
                                    textArray:(NSArray*)textArray
                                   colorArray:(NSArray*)colorArray
                                numberOfLines:(NSInteger)numberOfLines
                               backgroudColor:(UIColor*)backgroudColor
{
    
    YYTextView *attributedLabel = [[YYTextView alloc] initWithFrame:rect];
    NSInteger count = [textArray count];
    
    
    NSMutableAttributedString *attributedTextAll = [NSMutableAttributedString new];
    for (NSInteger i=0;i<count;i++)
    {
        UIColor *textColor =  colorArray[i];
        NSString *text = textArray[i];
        
        NSDictionary *attributes;
        if (fontSizes.count == 1)
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;// 字体的行间距
            attributes = @{
                           NSFontAttributeName:fontSizes[0],
                           NSParagraphStyleAttributeName:paragraphStyle
                           };
        }
        else
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;// 字体的行间距
            attributes = @{
                           NSFontAttributeName:fontSizes[i],
                           NSParagraphStyleAttributeName:paragraphStyle
                           };
        }
        
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
        if (textColor.CGColor)
        {
            [attributedText removeAttribute:(NSString *)kCTForegroundColorAttributeName range:NSMakeRange(0, [text length])];
            
            [attributedText addAttribute:(NSString *)kCTForegroundColorAttributeName
                                   value:(id)textColor.CGColor
                                   range:NSMakeRange(0, text.length)];
        }
        [attributedTextAll appendAttributedString:attributedText];
    }
    
    attributedLabel.attributedText = attributedTextAll;
    attributedLabel.backgroundColor = backgroudColor?:[UIColor clearColor];
    attributedLabel.userInteractionEnabled = NO;
    return attributedLabel;
    
}


@end
