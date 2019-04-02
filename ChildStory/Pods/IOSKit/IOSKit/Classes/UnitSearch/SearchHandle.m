//
//  SearchHandle.m
//  kp
//
//  Created by zhang yyuan on 2017/6/12.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <IOSKit/SearchHandle.h>

#import <IOSKit/IOSKit.h>

@implementation SearchHandle

- (instancetype)initWithFrame:(CGRect)frame Tip:(NSString *)tip Delegate:(id<SearchHandleDelegate>)delegate
{
    searchDelegate = delegate;
    searchText = @"";
    timer = nil;
    _returnEndSearch = NO;
    unEdit = NO;
    
    searchTip = tip;
    
    _SC = kUIColorFromRGB(0xF3F3F3);
    _SCImage = ImageName(@"common_top_search");
    _SCImageClose = ImageName(@"common_delete");
    _SCF = 13;
    
    self = [super initWithFrame:frame];
    if (self) {
        // 搜索框
        [self setBackgroundColor:_SC];
        [self setFont:FontSize(_SCF)];
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self setReturnKeyType:UIReturnKeySearch];
        [self setEnablesReturnKeyAutomatically:YES];
        [self setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.layer setCornerRadius:4];
        [self.layer setBorderWidth:0];
        [self setClipsToBounds:YES];
        [self setDelegate:self];
        [self setLeftViewMode:UITextFieldViewModeAlways];
        [self addTarget:self action:@selector(toTextChange:) forControlEvents:UIControlEventEditingChanged];
        self.keyboardType = UIKeyboardTypeDefault;
        
        [self setLeftViewTip:nil];
    }
    return self;
}

- (void)cleanAll:(UIButton *)sender{
    [sender removeFromSuperview];
    
    self.text = @"";
    searchText = @"";
    if (searchDelegate && [searchDelegate respondsToSelector:@selector(searchText:)]) {
        
        [searchDelegate searchText:searchText];
    }
    
    [self setLeftViewTip:nil];
    
    [self becomeFirstResponder];
}


- (void)searchTimeIn{
    
    if (inEditText) {
        inEditText = NO;
        
    }else{
        if (!searchText || ![searchText isEqualToString:self.text]) {
            if (self.text) {
                searchText = self.text;
            }else{
                searchText = @"";
            }
            
            if (searchDelegate && [searchDelegate respondsToSelector:@selector(searchText:)] && !_returnEndSearch) {
                
                [searchDelegate searchText:searchText];
            }
        }
    }
}

- (void)setToSearchText:(NSString *)text{
    self.text = text;
    
    if (!searchText || ![searchText isEqualToString:self.text]) {
        if (self.text) {
            searchText = self.text;
        }else{
            searchText = @"";
        }
        
        if (searchDelegate && [searchDelegate respondsToSelector:@selector(searchText:)]) {
            
            [searchDelegate searchText:searchText];
        }
    }
    
}

// 点击筛选是搜索  不要等点击搜索才搜索
- (void)startSearch {
    if (inEditText) {
        inEditText = NO;
        
    }else{
        if (self.text) {
            searchText = self.text;
        }else{
            searchText = @"";
        }
        
        if (searchDelegate && [searchDelegate respondsToSelector:@selector(searchText:)]) {
            
            [searchDelegate searchText:searchText];
        }
        
    }
}

#define LeftMarkBtnTag 14507
- (void)setLeftViewTip:(UIView *)view{
    if (view) {
        [self setLeftView:view];
        
        unEdit = YES;
        
        UIButton *dBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, 0, 40, self.frame.size.height)];
        [dBtn setImageEdgeInsets:UIEdgeInsetsMake((dBtn.frame.size.height - 20)/2, 10, (dBtn.frame.size.height - 20)/2, 10)];
        [dBtn setImage:_SCImageClose forState:UIControlStateNormal];
        [dBtn addTarget:self action:@selector(cleanAll:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:dBtn];
        
        [self setPlaceholder:nil];
        
        [self resignFirstResponder];
    }else{
        UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
        [leftBtn setImage:_SCImage forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(searchLeftAction) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.tag = LeftMarkBtnTag;
        self.leftView = leftBtn;
        
        unEdit = NO;
        [self setPlaceholder:searchTip];
    }
}

- (void)setSCImage:(UIImage *)SCImage
{
    _SCImage = SCImage;
    UIButton * leftBtn = self.leftView;
    [leftBtn setImage:_SCImage forState:UIControlStateNormal];
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return !unEdit;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (searchDelegate && [searchDelegate respondsToSelector:@selector(searchReady)]) {
        [searchDelegate searchReady];
    }
    
    if (!timer && !_returnEndSearch) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchTimeIn) userInfo:nil repeats:YES];
        [timer fire];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    // 若键盘收起了 如果textField.text 有数据，触发一次搜索
    if (textField.text && [textField.text length]) {
        inEditText = NO;
        [self searchTimeIn];
    }
    
    searchText = nil;
    if (searchDelegate && [searchDelegate respondsToSelector:@selector(searchEnd)]) {
        [searchDelegate searchEnd];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    
    if (_returnEndSearch && searchDelegate && [searchDelegate respondsToSelector:@selector(searchText:)]) {
        
        [searchDelegate searchText:textField.text];
    }
    
    return YES;
}

- (void)toTextChange:(UITextField *)textField{
    NSLog(@"textFiedl = %@",textField.text);
    
    if (searchDelegate && [searchDelegate respondsToSelector:@selector(searchHandText:)]) {
        [searchDelegate searchHandText:textField.text];
    }
    
    inEditText = YES;
}

- (void)searchLeftAction
{
    if (searchDelegate && [searchDelegate respondsToSelector:@selector(searchHandLeftAction:)]) {
        [searchDelegate searchHandLeftAction:self];
    }
    
}

@end

