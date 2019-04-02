//
//  GeneralConfig+Extend.m
//  Pods
//
//  Created by zhang yyuan on 2018/9/17.
//

#import <IOSKit/GeneralConfig+Extend.h>

#import <IOSKit/MulSelectView.h>

///** 快批报表 */
//KPAPP_TYPE_Managerside = 0,
//
///** 快批开单器 */
//KPAPP_TYPE_Useside = 1,
//
///** 云店 */
//KPAPP_TYPE_Cloudstoreside = 2,
//
///** 管理后台 */
//KPAPP_TYPE_Backend = 3,
//
///** 经销商管理系统 */
//KPAPP_TYPE_Salesystem = 4,
//
///** 经销商系统快批端 */
//KPAPP_TYPE_Bossmanager = 5,
//
///** 运营管理系统 */
//KPAPP_TYPE_Oss = 6,
//KPAPP_TYPE_All = 65535,

@implementation GeneralConfig (Extend)

+ (void)ConfigMulSelectView:(id)selectView {
    if (!selectView) {
        return;
    }
    if ([selectView isKindOfClass:[HorizontallySelectView class]]) {
        ((HorizontallySelectView *)selectView).selectedItemUI = kUIColorFromRGB(0x000000);
        ((HorizontallySelectView *)selectView).bgColor = kUIColorFromRGBAlpha(0x000000, 0.6);
        ((HorizontallySelectView *)selectView).defSize = 17;
        
        ((HorizontallySelectView *)selectView).radio_check = ImageName(@"common_check_white");
        ((HorizontallySelectView *)selectView).radio_check_sel = ImageName(@"common_check");
        
        ((HorizontallySelectView *)selectView).radio_2_check = ImageName(@"common_tabcheck_clean");
        ((HorizontallySelectView *)selectView).radio_2_check_sel = ImageName(@"common_tabcheck");
        
        ((HorizontallySelectView *)selectView).arrange_none = ImageName(@"common_arrange_none");
        ((HorizontallySelectView *)selectView).arrange_down = ImageName(@"common_arrange_down");
        ((HorizontallySelectView *)selectView).arrange_up = ImageName(@"common_arrange");
        
    } else if ([selectView isKindOfClass:[VerticallySelectView class]]) {
        ((VerticallySelectView *)selectView).arrange_down = ImageName(@"common_arrange_down");
        ((VerticallySelectView *)selectView).arrange_up = ImageName(@"common_arrange");
        
        ((HorizontallySelectView *)selectView).defSize = 15;
    }
}

@end
