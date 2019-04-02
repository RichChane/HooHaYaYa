//
//  GeneralConfig+Extend.h
//  Pods
//
//  Created by zhang yyuan on 2018/9/17.
//

#import <IOSKit/GeneralConfig.h>

#define MainViewFrame  CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - GC.topBarNormalHeight - GC.navBarHeight)

@interface GeneralConfig (Extend)

+ (void)ConfigMulSelectView:(id)selectView;

@end
