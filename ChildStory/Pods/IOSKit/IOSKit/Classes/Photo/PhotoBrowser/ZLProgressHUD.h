//
//  ZLProgressHUD.h
//  ZLPhotoBrowser
//
//  Created by long on 16/2/15.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HUDBlock)(void);
@interface ZLProgressHUD : UIView

@property (nonatomic, copy)HUDBlock hudTimeOutBlock;

- (void)show;
- (void)showWithTime:(NSInteger)time;

- (void)hide;

@end
