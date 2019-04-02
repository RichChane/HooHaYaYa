//
//  KPWKWebViewVC.h
//  kp
//
//  Created by gzkp on 2018/9/27.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "GeneralViewController.h"

typedef enum : NSUInteger {
    WebViewForViewClause = 100,
    
    
} WebViewType;

@protocol KPWKWebViewVCDelegate;

@interface KPWKWebViewVC : GeneralViewController

@property (nonatomic,assign) BOOL isPresent;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *rightBtnText;
@property (nonatomic,copy) dispatch_block_t rightAction;
@property (nonatomic,assign) WebViewType webType;
@property (nonatomic,copy) dispatch_block_t scrollToBottom;
@property (nonatomic,weak) id simpleDelegate;

@end

@protocol KPWKWebViewVCDelegate

- (void)webViewClickRightBtn;


@end
