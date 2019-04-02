//
//  MESearchTextField.m
//  kp
//
//  Created by gzkp on 2017/6/25.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "MESearchTextField.h"
#import "GeneralConfig.h"

@implementation MESearchTextField


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.tintColor = GC.MC;
        [self setValue:kUIColorFromRGB(0xCCCCCC) forKeyPath:@"_placeholderLabel.textColor"];
        
        
    }
    return self;
}

- (void)setCurserOffset:(CGFloat)curserOffset
{
    _curserOffset = curserOffset;
    
}







// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
//-(CGRect)editingRectForBounds:(CGRect)bounds
//{
//    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
//    return inset;
//}


@end
