//
//  GeneralTableController.h
//  IOSKit
//
//  Created by zhang yyuan on 2018/2/23.
//

#import <IOSKit/GeneralViewController.h>

#import <IOSKit/GeneralModelCell.h>
#import <IOSKit/GeneralModelSection.h>

#import <IOSKit/GeneralModelView.h>

#import <IOSKit/SearchHandle.h>


@interface GeneralTableController : GeneralViewController{
    
    
    //////////////////////////////////////////////////////////// table
    
    NSInteger generalTableType;          // 类型
    
    NSArray<NSArray<GeneralCellModel *> *> *generalCells;
    NSArray<GeneralSectionModel *> *generalSections;
    
    UITableView *mainTableView;
    UITableViewStyle tableViewStyle; // 默认为 UITableViewStylePlain
    id extendTableData;           //
    
    /// 是否隐藏cell的分隔线，默认为NO；系统的方法不能使用
    BOOL isHideCellSeparator;
    /// 分割线与左边界的距离  默认是15
    CGFloat separatorLeftEdg;
    /// 分割线与右边界的距离  默认是0
    CGFloat separatorRightEdg;
    
    GeneralToView *headerView;
    GeneralToView *footerView;
    
    GeneralToView *upHeaderView;          // 如果 开启了 openHeaderLoad、则被系统滚动占有
    
    GeneralToView *tableHeaderView;         // 可用于下拉
    GeneralToView *tableFooterView;         // 可用于上拉
    
    BOOL openHeaderLoad;      // 是否开启上拉加载更多
    BOOL openFooterLoad;      // 是否开启下拉加载更多
    BOOL isFristLoadFooter;      // 是否首次下拉加载更多
    id moreTableData;       // 加载更多数据的数据类型
    
    BOOL isDesc;
    
    BOOL isMultiSelectModel;        // 是否进入多选模式
    
    ///////////////////////////////////////////////////////// search
    
    BOOL isSearch;          // 是否为搜索 Controller
    
    SearchHandle *searchView;
    
    BOOL isLoad;
    BOOL isInit;        // 是否已经初始化
    
    NSString *searchToTip;        // 搜索提示
    
    UIScrollView *mainRecordView;       // 最近记录
    CGFloat nowRecordHeight;
    
    NSIndexPath *scrollIndexPath;       // 偏移位置
    UITableViewScrollPosition scrollPosition;
    
    ///前多少的cell不需要分割线
    NSInteger separatorHideAtRow;
    
}

@property NSInteger searchInitType;             // 一般用于初始化，第一次有效，用完要手动重置
@property (nonatomic ,strong) id searchToValue;
@property (nonatomic ,strong) NSString *searchText;

@property CGFloat searchHeight;


- (instancetype)initWithTable;          // 以 table 的形式初始化

- (void)reloadDataWithType;

- (void)cleanTable;

- (void)endRefreshing;          // 结束刷新

@end

#import <IOSKit/GeneralTableController+Observer.h>
