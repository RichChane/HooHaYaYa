//
//  CustomTextInputVC.m
//  kpkd
//
//  Created by lkr on 2018/8/6.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "CustomTextInputVC.h"
#import <KPFoundation/KPFoundation.h>
#import <YYKit/YYKit.h>
#import "GeneralConfig.h"
#import "GMUtilsHeader.h"

@interface CustomTextInputVC ()<YYTextViewDelegate>

@property (nonatomic, copy) NSString * titleStr;

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, copy) NSString * text;

@property (nonatomic, assign) NSInteger textLength;
@property (nonatomic, assign) NSInteger textMaxLength;

@property (nonatomic, strong) YYTextView * textView;
@property (nonatomic, strong) UILabel * textLengthLabel;

@property (nonatomic, assign) BOOL isHaveFinishBtn;
@end

@implementation CustomTextInputVC

- (instancetype)initWithTitle:(NSString *)title AndPlaceholder:(NSString *)placeholder AndText:(NSString *)text AndTextMaxLength:(NSInteger)textMaxLength {
    if (self = [super init]) {
        
        _titleStr = title;
        _placeholder = placeholder;
        _text = text;
        _textMaxLength = textMaxLength;
        _isHaveFinishBtn = YES;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title AndPlaceholder:(NSString *)placeholder AndText:(NSString *)text AndTextMaxLength:(NSInteger)textMaxLength IsHaveFinish:(BOOL)isHaveFinishBtn {
    if (self = [super init]) {
        
        _titleStr = title;
        _placeholder = placeholder;
        _text = text;
        _textMaxLength = textMaxLength;
        _isHaveFinishBtn = isHaveFinishBtn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customTitleStr = _titleStr;
    if (_isHaveFinishBtn) {
        [self addRightBarButtonItem:ML(@"完成")];
    }
    [self addLeftBarButtonItem:ImageName(@"back")];
    [self createMainView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
    [_textView setSelectedRange:NSMakeRange(0, 0)];
}

#pragma mark - view
- (void)createMainView {
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, ASIZE(10) + GC.navBarHeight+GC.topBarNowHeight, SCREEN_WIDTH, ASIZE(270))];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    YYTextView * textView = [[YYTextView alloc] initWithFrame:CGRectMake(ASIZE(15), ASIZE(10), bgView.frame.size.width - ASIZE(30), ASIZE(230))];
    textView.tintColor = GC.MC;
    textView.font = FontSize(18);
    textView.placeholderText = _placeholder;
    textView.placeholderTextColor = kUIColorFromRGBAlpha(0x000000, 0.2);
    textView.placeholderFont = FontSize(18);
    textView.delegate = self;
    [bgView addSubview:textView];
    _textView = textView;
    
    _textLength = 0;
    if (_text) {
        textView.text = _text;
        _textLength = _text.length;
    }
    
    UILabel * textLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(ASIZE(15), bgView.height - ASIZE(34), textView.width, ASIZE(21))];
    textLengthLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:textLengthLabel];
    _textLengthLabel = textLengthLabel;
    
    [textView becomeFirstResponder];
    [self setTextLengthColor];
}

#pragma mark - action
- (void)leftBarButtonItemClicked:(UIBarButtonItem *)barButtonItem {
    
    if (!_isHaveFinishBtn) {
        if (_textLength > _textMaxLength) {
            [GMUtils showQuickTipWithText:[NSString stringWithFormat:@"%@%ld%@",ML(@"最多"),_textMaxLength,ML(@"字哦~")]];
            return;
        }
        if (self.textInputBlock) {
            self.textInputBlock(_textView.text);
        }
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarButtonItemClicked:(UIBarButtonItem *)barButtonItem {
    
    if (_textLength > _textMaxLength) {
        [GMUtils showQuickTipWithText:[NSString stringWithFormat:@"%@%ld%@",ML(@"最多"),_textMaxLength,ML(@"字哦~")]];
        return;
    }
    
    if (self.textInputBlock) {
        self.textInputBlock(_textView.text);
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)setTextLengthColor {
    _textLengthLabel.text = [NSString stringWithFormat:@"%ld/%ld",_textLength,_textMaxLength];
    if (_textLength > _textMaxLength) {
        _textLengthLabel.textColor = [UIColor redColor];
    }else {
        _textLengthLabel.textColor = kUIColorFromRGB(0x7F7F7F);
    }
}

#pragma mark - YYTextViewDelegate
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView{
    
    return YES;
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //不支持系统表情的输入
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    
    if ([self containEmoji:text]) {
        return NO;
    }
    
    return YES;
}
- (void)textViewDidChange:(YYTextView *)textView {
    _textLength = textView.text.length;
    if (_textLength > _textMaxLength) {
        textView.text = [textView.text substringToIndex:_textMaxLength];
        _textLength = textView.text.length;
    }
    [self setTextLengthColor];
    
}

/// 判断是否包含emoji
/// 参考地址：https://www.jianshu.com/p/5c44e7098761
- (BOOL) containEmoji:(NSString *)text
{
    NSUInteger len = [text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (len < 3) {// 大于2个字符需要验证Emoji(有些Emoji仅三个字符)
        return NO;
    }// 仅考虑字节长度为3的字符,大于此范围的全部做Emoji处理
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];Byte *bts = (Byte *)[data bytes];
    Byte bt;
    short v;
    for (NSUInteger i = 0; i < len; i++) {
        bt = bts[i];
        
        if ((bt | 0x7F) == 0x7F) {// 0xxxxxxxASIIC编码
            continue;
        }
        if ((bt | 0x1F) == 0xDF) {// 110xxxxx两个字节的字符
            i += 1;
            continue;
        }
        if ((bt | 0x0F) == 0xEF) {// 1110xxxx三个字节的字符(重点过滤项目)
            // 计算Unicode下标
            v = bt & 0x0F;
            v = v << 6;
            v |= bts[i + 1] & 0x3F;
            v = v << 6;
            v |= bts[i + 2] & 0x3F;
            
            // NSLog(@"%02X%02X", (Byte)(v >> 8), (Byte)(v & 0xFF));
            if ([self emojiInSoftBankUnicode:v] || [self emojiInUnicode:v]) {
                return YES;
            }
            
            i += 2;
            continue;
        }
        if ((bt | 0x3F) == 0xBF) {// 10xxxxxx10开头,为数据字节,直接过滤
            continue;
        }
        
        return YES; // 不是以上情况的字符全部超过三个字节,做Emoji处理
    }return NO;
}

- (BOOL) emojiInSoftBankUnicode:(short)code
{
    return ((code >> 8) >= 0xE0 && (code >> 8) <= 0xE5 && (Byte)(code & 0xFF) < 0x60);
}

- (BOOL) emojiInUnicode:(short)code
{
    if (code == 0x0023
        || code == 0x002A
        || (code >= 0x0030 && code <= 0x0039)
        || code == 0x00A9
        || code == 0x00AE
        || code == 0x203C
        || code == 0x2049
        || code == 0x2122
        || code == 0x2139
        || (code >= 0x2194 && code <= 0x2199)
        || code == 0x21A9 || code == 0x21AA
        || code == 0x231A || code == 0x231B
        || code == 0x2328
        || code == 0x23CF
        || (code >= 0x23E9 && code <= 0x23F3)
        || (code >= 0x23F8 && code <= 0x23FA)
        || code == 0x24C2
        || code == 0x25AA || code == 0x25AB
        || code == 0x25B6
        || code == 0x25C0
        || (code >= 0x25FB && code <= 0x25FE)
        || (code >= 0x2600 && code <= 0x2604)
        || code == 0x260E
        || code == 0x2611
        || code == 0x2614 || code == 0x2615
        || code == 0x2618
        || code == 0x261D
        || code == 0x2620
        || code == 0x2622 || code == 0x2623
        || code == 0x2626
        || code == 0x262A
        || code == 0x262E || code == 0x262F
        || (code >= 0x2638 && code <= 0x263A)
        || (code >= 0x2648 && code <= 0x2653)
        || code == 0x2660
        || code == 0x2663
        || code == 0x2665 || code == 0x2666
        || code == 0x2668
        || code == 0x267B
        || code == 0x267F
        || (code >= 0x2692 && code <= 0x2694)
        || code == 0x2696 || code == 0x2697
        || code == 0x2699
        || code == 0x269B || code == 0x269C
        || code == 0x26A0 || code == 0x26A1
        || code == 0x26AA || code == 0x26AB
        || code == 0x26B0 || code == 0x26B1
        || code == 0x26BD || code == 0x26BE
        || code == 0x26C4 || code == 0x26C5
        || code == 0x26C8
        || code == 0x26CE
        || code == 0x26CF
        || code == 0x26D1
        || code == 0x26D3 || code == 0x26D4
        || code == 0x26E9 || code == 0x26EA
        || (code >= 0x26F0 && code <= 0x26F5)
        || (code >= 0x26F7 && code <= 0x26FA)
        || code == 0x26FD
        || code == 0x2702
        || code == 0x2705
        || (code >= 0x2708 && code <= 0x270D)
        || code == 0x270F
        || code == 0x2712
        || code == 0x2714
        || code == 0x2716
        || code == 0x271D
        || code == 0x2721
        || code == 0x2728
        || code == 0x2733 || code == 0x2734
        || code == 0x2744
        || code == 0x2747
        || code == 0x274C
        || code == 0x274E
        || (code >= 0x2753 && code <= 0x2755)
        || code == 0x2757
        || code == 0x2763 || code == 0x2764
        || (code >= 0x2795 && code <= 0x2797)
        || code == 0x27A1
        || code == 0x27B0
        || code == 0x27BF
        || code == 0x2934 || code == 0x2935
        || (code >= 0x2B05 && code <= 0x2B07)
        || code == 0x2B1B || code == 0x2B1C
        || code == 0x2B50
        || code == 0x2B55
        || code == 0x3030
        || code == 0x303D
        || code == 0x3297
        || code == 0x3299
        // 第二段
        || code == 0x23F0) {
        return YES;
    }
    return NO;
}


@end
