//
//  KPSegmentView.m
//  kpkdpad
//
//  Created by lkr on 2018/5/2.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "KPSegmentView.h"
#import "GeneralConfig.h"

@interface KPSegmentView()

/// 数组
@property (nonatomic, strong) NSArray <NSString *>* segArray;

/// 带边框的View
@property (nonatomic, strong) UIView * segLineView;

/// 当前选择的button
@property (nonatomic, strong) UIButton * currentButton;

@end

@implementation KPSegmentView

- (id)initWithFrame:(CGRect)frame AndSegmentArray:(NSArray *)segArray {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 2;
        _segArray = segArray;
        
        [self crateMainView];
        
    }
    return self;
}

- (void)crateMainView {
    if (!_segArray || _segArray.count < 2) {
        return;
    }
    NSInteger count = _segArray.count;
    
    CGFloat width = self.frame.size.width/count;
    CGFloat height = self.frame.size.height;
    
    for (int i = 0; i < count ; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000 + i;
        button.frame = CGRectMake((width + 1) * i, 0, width, height);
        [button setTitle:_segArray[i] forState:0];
        [button setTitleColor:kUIColorFromRGB(0x7F7F7F) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = FontSize(15);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (i == _currentIndex) {
            _currentButton = button;
        }
        
        if (i == 0) {
            button.frame = CGRectMake(0, 0, width + 1, height);
        }else if (i == count - 1) {
            button.frame = CGRectMake(width * i - 1, 0, width + 1, height);
        }else {
            button.frame = CGRectMake(width * i, 0, width, height);
        }
    }
    
    _segLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
    _segLineView.layer.cornerRadius = 2;
    _segLineView.layer.borderWidth = 1;
    _segLineView.layer.borderColor = GC.MC.CGColor;
    _segLineView.userInteractionEnabled = NO;
    [self addSubview:_segLineView];
    
    for (int j = 1; j < count; j++) {
        UIView * line = [[UIView alloc] init];
        if (j == 1) {
            line.frame = CGRectMake(width * j, 0, 1, height);
        }else {
            line.frame = CGRectMake(width * j - 1, 0, 1, height);
        }
        line.backgroundColor = GC.MC;
        [_segLineView addSubview:line];
    }
    
    _currentButton.selected = YES;
    _currentButton.backgroundColor = GC.MC;
    [self bringSubviewToFront:_currentButton];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    if (_currentButton.tag - 1000 == currentIndex) {
        return;
    }
    
    UIButton * button = [self viewWithTag:1000 + currentIndex];
    if (button) {
        [self buttonAction:button];
    }
    
}

- (void)buttonAction:(UIButton *)sender {
    
    if (_currentButton == sender) {
        return;
    }
    
    _currentButton.selected = NO;
    _currentButton.backgroundColor = [UIColor whiteColor];
    [self sendSubviewToBack:_currentButton];
    _currentButton = sender;
    _currentButton.selected = YES;
    _currentButton.backgroundColor = GC.MC;
    [self bringSubviewToFront:_currentButton];
    
    if (self.segBlock) {
        self.segBlock(_currentButton.tag - 1000);
    }
}


@end
