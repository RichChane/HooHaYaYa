//
//  ErrorTopLineView.h
//  kpkd
//
//  Created by gzkp on 2017/10/23.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ErrorTypExclamation,
    
    
} ErrorType;


@interface ErrorTopLineView : UIView

@property (nonatomic,strong) NSString *contentText;

- (id)initErrorViewWithFrame:(CGRect)frame errorType:(ErrorType)errorType contentText:(NSString *)contentText;




@end
