//
//  GeneralTableController+Observer.h
//  IOSKit
//
//  Created by zhang yyuan on 2018/2/23.
//

#import <IOSKit/GeneralTableController.h>

@protocol TableViewControllerDelegate <NSObject>


//必须实现
@required

/**
 刷新数据
 
 */
- (void)reloadFromCell:(id)msg;

/**
 获取二维码
 
 @param code 二维码
 */
- (void)productCode:(NSString *)code OtherMsg:(id)oterMsg;

/**
 切换模式
 
 @param mType 1表示批量，2表示单选，11 表示全选、取消全选
 */
- (void)changerModelType:(NSInteger)mType;

/**
 更换管理员操作
 
 @param otherStaff 新管理员
 @param code 验证码
 */
- (void)changeRootStaffTo:(id)otherStaff code:(NSString *)code type:(int32_t)type;

/**
 删除成员
 
 移交成员信息
 */
- (void)kickUserStaff:(id)delStaff staffTransfer:(id)staffTransfer;

@end


@interface GeneralTableController (Observer)<TableViewControllerDelegate, SearchHandleDelegate>


- (instancetype)initWithTableType:(NSInteger)type Object:(id)obj;

- (void)noData;         // 没有数据时调用此方法  子类实现
- (void)haveData;       // 有数据调用此方法  子类实现

- (void)upMoreData;         // 头部加载更多
- (void)downMoreData;       // 底部加载更多

#pragma mark OtherUI
- (void)buildNavUI;     // 生成导航条

- (void)willLoad;


#pragma mark all table view
- (GeneralViewSection *) createSectionHeadWithModel:(GeneralSectionModel *)f_Model ReuseIdentifier:(NSString *)r_id;
- (GeneralViewSection *) createSectionFootWithModel:(GeneralSectionModel *)f_Model ReuseIdentifier:(NSString *)r_id;

- (GeneralViewCell *) createCellWithFrameModel:(GeneralCellModel *)f_Model ReuseIdentifier:(NSString *)r_id;

- (GeneralToView *) createViewWithModel:(GeneralViewModel *)f_Model;

- (void)registerCell;


#pragma mark Observer
- (void)doFromEditModel:(id)model Type:(GeneralCellEditType)type;



/////////////////////////////////////////////    search

- (NSString *)getTipWithType;

- (BOOL)isSearchToReturnEnd;       // 是否需要点击搜索才进行搜索

#pragma mark SearchRecord

- (void)buildRecordView;

@end
