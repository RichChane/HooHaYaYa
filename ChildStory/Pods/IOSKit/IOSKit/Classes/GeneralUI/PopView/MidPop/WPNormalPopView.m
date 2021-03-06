//
//  KPNormalPopView.m
//  RCIOS-SDK
//
//  Created by gzkp on 2018/8/22.
//  Copyright © 2018年 RC. All rights reserved.
//

#import "WPNormalPopView.h"
#import "NSString+Size.h"


@interface WPNormalPopView()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) YYTextView *contentAttriLabel;


@end

#define normalWith ([UIScreen mainScreen].bounds.size.width - 30)
static const CGFloat leftDis = 33;

@implementation WPNormalPopView

{
    NSString *_title;
    CGSize _titleSize;
    NSString *_content;
    CGSize _contentSize;
    NSString *_alertTitle;
    CGSize _alertSize;
    
    //attris
    NSArray *_contents;
    NSArray *_colors;
    CGSize _contentAttriSize;
}

#pragma mark - init
- (instancetype)initWithTitle:(NSString*)title content:(NSString*)content cancelBtnTitle:(NSString*)cancelBtnTitle okBtnTitle:(NSString*)okBtnTitle  makeSure:(MakeSure)makeSure cancel:(Cancel)cancel
{
    return [self initWithTitle:title content:content alertTitle:nil cancelBtnTitle:cancelBtnTitle okBtnTitle:okBtnTitle makeSure:makeSure cancel:cancel];
}

- (instancetype)initWithTitle:(NSString*)title cancelBtnTitle:( NSString*)cancelBtnTitle okBtnTitle:(NSString*)okBtnTitle  makeSure:(MakeSure)makeSure cancel:(Cancel)cancel
{
    return [self initWithTitle:nil content:title alertTitle:nil cancelBtnTitle:cancelBtnTitle okBtnTitle:okBtnTitle makeSure:makeSure cancel:cancel];
}

- (instancetype)initWithTitle:(NSString*)title content:(NSString*)content alertTitle:(NSString *)alertTitle cancelBtnTitle:(NSString*)cancelBtnTitle okBtnTitle:(NSString*)okBtnTitle  makeSure:(MakeSure)makeSure cancel:(Cancel)cancel
{
    self = [super initWithCancelBtnTitle:cancelBtnTitle okBtnTitle:okBtnTitle];
    if (self) {
        
        self.cancel = cancel;
        self.makeSure = makeSure;
        _title = title;
        _content = content;
        _alertTitle = alertTitle;
        
        if ((_title == nil || _title.length == 0) && (_content == nil || _content.length == 0)) {
            _title = ML(@"系统错误");
        }
        
        CGFloat titleHeight= 0;
        if (_title && ![_title isEqualToString:@""])
        {
            _titleSize = [title sizeWithFont:FontSize(17) maxSize:CGSizeMake(normalWith - leftDis*2, 0)];
            titleHeight = _titleSize.height;
        }
        
        if (_content && ![_content isEqualToString:@""])
        {
            _contentSize = [self string:_content sizeWithFont:FontSize(17) maxSize:CGSizeMake(normalWith - leftDis*2, 0)];
        }
        
        CGFloat alertHeight = 0;
        if (_alertTitle && _alertTitle.length) {
            _alertSize = [_alertTitle sizeWithFont:FontSize(15) maxSize:CGSizeMake(normalWith - leftDis*2, 0)];
            alertHeight = _alertSize.height + 15;
            _alertSize.height = alertHeight;
        }
        
        self.contentAligment = NSTextAlignmentCenter;
    }
    return self;
    
}
//富文本展示
- (instancetype)initAttriWithTitle:(NSString*)title contents:(NSArray*)contents colors:(NSArray *)colors cancelBtnTitle:( NSString*)cancelBtnTitle okBtnTitle:(NSString*)okBtnTitle  makeSure:(MakeSure)makeSure cancel:(Cancel)cancel
{
    self = [super initWithCancelBtnTitle:cancelBtnTitle okBtnTitle:okBtnTitle];
    if (self) {
        
        self.cancel = cancel;
        self.makeSure = makeSure;
        _title = title;
        _contents = contents;
        _colors = colors;
        
        
        CGFloat titleHeight= 0;
        if (_title && ![_title isEqualToString:@""])
        {
            _titleSize = [title sizeWithFont:FontSize(17) maxSize:CGSizeMake(normalWith - leftDis*2, 0)];
            titleHeight = _titleSize.height;
        }
        
        CGFloat contentHeight = 0;
        if (_contents && _contents.count )
        {
            NSString *text = @"";
            for (NSString *content in contents) {
                text = [NSString stringWithFormat:@"%@%@",text,content];
            }
            
            _contentAttriSize = [self string:text sizeWithFont:FontSize(17) maxSize:CGSizeMake(normalWith - leftDis*2, 0)];
            contentHeight = _contentAttriSize.height + 20;
        }
        
    }
    return self;
}

#pragma mark - createItems
- (void)createItems
{
    self.contentView = [UIView  new];
    self.topView = [UIView new];
    
    CGFloat labelWidth = normalWith - leftDis*2;
    CGFloat nowY = 0;
    if (_alertTitle && _alertTitle.length) {
        
        UIView *alertBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, normalWith, _alertSize.height)];
        alertBgView.backgroundColor = kUIColorFromRGB(0xFA533D);
        [self.topView addSubview:alertBgView];
        
        UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftDis, 0, labelWidth, _alertSize.height)];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.font = FontSize(15);
        alertLabel.textColor = [UIColor whiteColor];
        alertLabel.text = _alertTitle;
        alertLabel.numberOfLines = 0;
        [alertBgView addSubview:alertLabel];
        nowY = CGRectGetMaxY(alertBgView.frame);
    }
    
    if (_title && ![_title isEqualToString:@""])
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDis, nowY+30, labelWidth, _titleSize.height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:ASIZE(17)];
        _titleLabel.textColor = kUIColorFromRGB(0x000000);
        _titleLabel.text = _title;
        _titleLabel.numberOfLines = 0;
        [self.topView addSubview:_titleLabel];
        nowY = CGRectGetMaxY(_titleLabel.frame);
    }
    
    self.topView.frame = CGRectMake(0, 0, normalWith, nowY+15);
    
    nowY = 0.0;
    if (_content && ![_content isEqualToString:@""])
    {
        if (self.popType == KPPopTypeNormal) {
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDis, nowY, labelWidth, _contentSize.height+20)];
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineSpacing = 10;
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
            _contentLabel.attributedText = [[NSAttributedString alloc] initWithString:_content attributes:attributes];
            //_contentLabel.text = _content;
        }else if (self.popType == KPPopTypeExplain){
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDis, 40, labelWidth, _contentSize.height+20)];
            
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineSpacing = 10;
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
            _contentLabel.attributedText = [[NSAttributedString alloc] initWithString:_content attributes:attributes];
            
        }
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.textAlignment = self.contentAligment;
        _contentLabel.font = [UIFont systemFontOfSize:17];
        _contentLabel.textColor = kUIColorFromRGB(0x282b34);
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        if (_title && _title.length) {
            nowY = CGRectGetMaxY(_contentLabel.frame)+15;
            
        }else{
            nowY = CGRectGetMaxY(_contentLabel.frame);
            
        }
        
        
    }
    if (_contents && _contents.count){
        
        NSMutableArray *fontArray = [NSMutableArray array];
        for (int i = 0; i < _contents.count; i ++) {
            [fontArray addObject:FontSize(17)];
        }
        _contentAttriLabel = [UIFactory createAttributedLabelWithFrame:CGRectMake(leftDis, nowY+15, labelWidth, _contentAttriSize.height + 15) fontArray:fontArray textArray:_contents colorArray:_colors numberOfLines:0 backgroudColor:nil];
        _contentAttriLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_contentAttriLabel];
        nowY = CGRectGetMaxY(_contentAttriLabel.frame)+15;
    }
    
    
    self.contentView.frame = CGRectMake(0, 0, normalWith, nowY);
    
    /// 重新设置高度
    if ((_title && ![_title isEqualToString:@""]) && (!_content && !_contents)) {
        
        if (self.topView.frame.size.height < 74) {
            self.topView.frame = CGRectMake(0, 0, normalWith, 74);
            _titleLabel.frame = CGRectMake(leftDis, 74/2 - _titleSize.height/2, labelWidth, _titleSize.height);
        }
        
    }else if ((_content && ![_content isEqualToString:@""]) && !_titleLabel && !_contents){
        _contentLabel.frame = CGRectMake(leftDis, 15, _contentLabel.frame.size.width, _contentLabel.frame.size.height);
        self.contentView.frame = CGRectMake(0, 0, normalWith, CGRectGetMaxY(self.contentView.frame)+20+15);
        
    }
}

#pragma mark - show&dismiss
- (void)showPopView
{
    [self createItems];
    [self refreshCenterView:self.topView contentView:self.contentView];
    if (_contents) {// 富文本绘制有延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super showPopView];
        });
    }else{
        [super showPopView];
    }
    
}

#pragma mark - set&get
- (void)setContentAligment:(NSTextAlignment)contentAligment
{
    _contentAligment = contentAligment;
    _contentLabel.textAlignment = contentAligment;
}

- (void)setTitleAligment:(NSTextAlignment)titleAligment
{
    _titleLabel.textAlignment = titleAligment;
}

#pragma mark - sure&cancel btn
- (void)clickSureBtn:(UIButton *)sender
{
    if (self.makeSure) {
        self.makeSure();
    }
    [super clickSureBtn:sender];
    
}

- (void)clickCancleBtn:(UIButton *)sender
{
    if (self.cancel) {
        self.cancel();
    }
    [super clickCancleBtn:sender];
    
}


//返回字符串所占用的尺寸.
-(CGSize)string:(NSString *)string sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attrs = @{
                            NSFontAttributeName:font,
                            NSParagraphStyleAttributeName:paragraphStyle
                            };
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
