//
//  GeneralTableController.m
//  IOSKit
//
//  Created by zhang yyuan on 2018/2/23.
//

#import <IOSKit/GeneralTableController.h>

#import <MJRefresh/MJRefresh.h>
#import <IOSKit/RCMJRefreshExternHeader.h>

#import <IOSKit/IOSKit.h>
#import <KPFoundation/KPFoundation.h>

@interface GeneralTableController ()

@end

@implementation GeneralTableController

- (instancetype)initWithTable {
    
    self = [super init];
    if (self) {
        
        openHeaderLoad = NO;
        openFooterLoad = NO;
        isFristLoadFooter = NO;
        
        _searchText = nil;
        _searchToValue = nil;
        searchView = nil;
        isLoad = NO;
        
        generalSections = nil;
        headerView = nil;
        
        _searchHeight = 30;
        separatorLeftEdg = 15;
        separatorRightEdg = 0;
        
        scrollIndexPath = nil;
        scrollPosition = UITableViewScrollPositionTop;
        
        tableViewStyle = UITableViewStylePlain; // 默认为 UITableViewStylePlain
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mainTableView = nil;
    
    if (isSearch) {
        
        searchToTip = [self getTipWithType];
        
        isLoad = YES;
    }
    
    [self buildNavUI];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //刷新数据界面
    
    if (self.needReload) {
        
        [self willLoad];
        self.needReload = NO;
    }
    
    [self refreshForView];
    
    if (isSearch) {
        if (isLoad) {
            [self buildRecordView];
            
            isLoad = NO;
        }
        
        if ((_searchText || _searchToValue) && mainTableView && mainRecordView) {
            [self.view sendSubviewToBack:mainRecordView];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Private methods

- (void)refreshForView
{
    if (!self.isViewLoaded) {
        return;
    }
    
    CGRect tFrame = [self getShowScreen];
    
    if (!mainTableView) {
        
        mainTableView = [[UITableView alloc] initWithFrame:tFrame style:tableViewStyle];
        [mainTableView setBackgroundColor:GC.BG];
        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mainTableView.estimatedRowHeight = 0;
        
        mainTableView.dataSource = self;
        mainTableView.delegate = self;
        
        [self registerCell];
        
        [self.view addSubview:mainTableView];
        
        [self.view sendSubviewToBack:mainTableView];         // 为了让底部导航放在最前面
        
        // 如果是自定义导航栏，不做位置偏移
        if (self.isSelfNav) {
            if (@available(iOS 11.0, *)) {
                mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }else {
                self.automaticallyAdjustsScrollViewInsets = NO;
            }
        }
    }
    
    if (headerView) {
        if (![[self.view subviews] containsObject:headerView]) {
            [self.view addSubview:headerView];
        }
        
        tFrame.origin.y += headerView.frame.size.height;
        tFrame.size.height -= headerView.frame.size.height;
        
        CGRect hFrame = headerView.frame;
        hFrame.origin.y = tFrame.origin.y - hFrame.size.height;
        [headerView setFrame:hFrame];
    }
    if (footerView) {
        if (![[self.view subviews] containsObject:footerView]) {
            [self.view addSubview:footerView];
        }
        tFrame.size.height -= footerView.frame.size.height;
        
        CGRect fFrame = footerView.frame;
        fFrame.origin.y = tFrame.size.height + tFrame.origin.y;
        [footerView setFrame:fFrame];
    }
    
    [mainTableView setFrame:tFrame];
    
    if (openHeaderLoad) {
        // 下拉刷新
        if (!mainTableView.mj_header) {
            mainTableView.mj_header = [RCMJRefreshExternHeader headerWithRefreshingBlock:^{
                [self upMoreData];
            }];
        }
        if (upHeaderView) {
            [upHeaderView removeFromSuperview];
        }
        
    } else {
        mainTableView.mj_header = nil;
        
        if (upHeaderView) {
            [upHeaderView removeFromSuperview];
            [mainTableView addSubview:upHeaderView];
        }
    }
    
    if (openFooterLoad) {
        // 上拉刷新
        if (!mainTableView.mj_footer) {
            mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [self downMoreData];
            }];
        }
        
    } else {
        mainTableView.mj_footer = nil;
    }
    
    if (tableHeaderView) {
        mainTableView.tableHeaderView = tableHeaderView;
    }else{
        mainTableView.tableHeaderView = nil;
    }
    
    if (tableFooterView) {
        mainTableView.tableFooterView = tableFooterView;
    }else{
        mainTableView.tableFooterView = nil;
    }
    
    //刷新界面
    [mainTableView reloadData];
    
    if (scrollIndexPath && mainTableView) {
        [mainTableView scrollToRowAtIndexPath:[scrollIndexPath copy]
                             atScrollPosition:scrollPosition
                                     animated:NO];
        
        scrollIndexPath = nil;
    }
    
    if (isFristLoadFooter && mainTableView.mj_footer) {
        isFristLoadFooter = NO;
        [mainTableView.mj_footer beginRefreshing];
    }
}

#pragma mark - Public methods

- (void)reloadDataWithType{
    if (mainTableView) {
        //刷新界面
        [self refreshForView];
        
        
        [self.view bringSubviewToFront:mainTableView];
        
        if (generalCells && generalCells.count > 0 && generalSections.count >0) {
            [self haveData];
        }else {
            [self noData];
        }
        
        [[MainHandle Share] upBarBuildToView:self.view];
        
        
    }
}

- (void)cleanTable{
    generalCells = nil;
    generalSections = nil;
    
    if (headerView) {
        [headerView removeFromSuperview];
        headerView = nil;
    }
    if (footerView) {
        [footerView removeFromSuperview];
        footerView = nil;
    }
    
    [self refreshForView];
    
    [self.view sendSubviewToBack:mainTableView];     // 为了让底部导航放在最前面
}

- (void)endRefreshing {
    if (mainTableView.mj_header.isRefreshing) {
        [mainTableView.mj_header endRefreshing];
    }
    if (mainTableView.mj_footer.isRefreshing) {
        [mainTableView.mj_footer endRefreshing];
    }
    isFristLoadFooter = NO;
}

#pragma mark - UITableViewDalegate and UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (generalSections && generalCells && [generalCells count] == [generalSections count] && generalSections.count>0) {
        
        return [generalSections count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return ((GeneralSectionModel *)generalSections[section]).headHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ((GeneralSectionModel *)generalSections[section]).footHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([generalCells[section] isKindOfClass:[NSArray class]]) {
        return [generalCells[section] count];
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = GC.BG;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *kSectionIdentifier = [NSString stringWithFormat:@"section_header_%ld", generalSections[section].sectionType];
    GeneralViewSection *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionIdentifier];
    
    if (!sectionView) {
        sectionView = [self createSectionHeadWithModel:generalSections[section] ReuseIdentifier:kSectionIdentifier];
    }
    
    [sectionView refreshContact:generalSections[section]];
    
    return sectionView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSString *kSectionIdentifier = [NSString stringWithFormat:@"section_footer_%ld", generalSections[section].sectionType];
    GeneralViewSection *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionIdentifier];
    
    if (!sectionView) {
        sectionView = [self createSectionFootWithModel:generalSections[section] ReuseIdentifier:kSectionIdentifier];
    }
    
    [sectionView refreshContact:generalSections[section]];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([generalCells[indexPath.section] isKindOfClass:[NSArray class]]) {
        return ((GeneralCellModel *)generalCells[indexPath.section][indexPath.row]).cellFrame.size.height;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GeneralCellModel *oneModel = nil;
    
    if ([generalCells[indexPath.section] isKindOfClass:[NSArray class]]) {
        
        oneModel = generalCells[indexPath.section][indexPath.row];
        
    }
    
    if (!oneModel) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"出错"];
        return cell;
    }
    
    NSString *kCellIdentifier = [NSString stringWithFormat:@"cell_%ld", oneModel.cellType];
    GeneralViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [self createCellWithFrameModel:oneModel ReuseIdentifier:kCellIdentifier];
    }
    
    if (!isHideCellSeparator) {
        [GeneralUIUse CleanAllLine:cell];
    }
    
    [cell refreshContact:oneModel];
    
    if (!isHideCellSeparator) {
        
        if (indexPath.row == 0) {
            
        }else{
            if (indexPath.row <= separatorHideAtRow) {
                
            }else {
                
                [GeneralUIUse AddLineUp:cell Color:GC.LINE LeftOri:separatorLeftEdg RightOri:separatorRightEdg];
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GeneralCellModel *oneModel = nil;
    
    if ([generalCells[indexPath.section] isKindOfClass:[NSArray class]]) {
        
        oneModel = generalCells[indexPath.section][indexPath.row];
        
    }
    
    GeneralViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell selectedToDo];
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeneralCellModel *oneModel = nil;
    
    if ([generalCells[indexPath.section] isKindOfClass:[NSArray class]]) {
        
        oneModel = generalCells[indexPath.section][indexPath.row];
        
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:2];
    __weak typeof(self) weakSelf = self;
    
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeSameBuy)) {
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                   title:ML(@"同品\n下单")
                                                                                 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                     
                                                                                     [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeSameBuy];
                                                                                 }];
        deleteRowAction.backgroundColor = kUIColorFromRGB(0xFC9F06);
        
        [arr addObject:deleteRowAction];
    }
    
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeDelete)) {
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                   title:ML(@"删除")
                                                                                 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                     
                                                                                     [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeDelete];
                                                                                 }];
        deleteRowAction.backgroundColor = kUIColorFromRGB(0xEC2121);
        
        [arr addObject:deleteRowAction];
    }
//    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeBackup)) {
//        NSString *btnTitle = ML(@"停用");
//        if (oneModel.isSelectIn) {
//            btnTitle = ML(@"启用");
//        }else{
//            btnTitle = ML(@"停用");
//        }
//
//        UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
//                                                                                 title:btnTitle
//                                                                               handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//
//                                                                                   [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeBackup];
//                                                                               }];
//        editRowAction.backgroundColor = kUIColorFromRGB(0xC0C0C0);
//
//        [arr addObject:editRowAction];
//    }
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeDetails)) {
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                   title:ML(@"详情")
                                                                                 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                     
                                                                                     [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeDetails];
                                                                                 }];
        deleteRowAction.backgroundColor = kUIColorFromRGB(0xFD6D00);
        
        [arr addObject:deleteRowAction];
    }
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeOwn)) {
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                   title:ML(@"收款")
                                                                                 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                     
                                                                                     [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeOwn];
                                                                                 }];
        deleteRowAction.backgroundColor = kUIColorFromRGB(0xFD6D00);
        
        [arr addObject:deleteRowAction];
    }
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeBuild)) {
        UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                 title:ML(@"修改")
                                                                               handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                   [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeBuild];
                                                                                   
                                                                               }];
        editRowAction.backgroundColor = kUIColorFromRGB(0x4076CE);
        
        [arr addObject:editRowAction];
    }
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypePrint)) {
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                   title:ML(@"打印")
                                                                                 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                     
                                                                                     [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypePrint];
                                                                                 }];
        deleteRowAction.backgroundColor = kUIColorFromRGB(0xFF9F00);
        
        [arr addObject:deleteRowAction];
    }
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeOut)) {
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                   title:ML(@"出库")
                                                                                 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                     
                                                                                     [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeOut];
                                                                                 }];
        deleteRowAction.backgroundColor = GC.MC;
        
        [arr addObject:deleteRowAction];
    }
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeCopy)) {
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                   title:ML(@"抄单")
                                                                                 handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                     
                                                                                     [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeCopy];
                                                                                 }];
        deleteRowAction.backgroundColor = kUIColorFromRGB(0xD8D8D8);
        
        [arr addObject:deleteRowAction];
    }
    
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeMultiSelect)) {
        UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                 title:ML(@"多选\n操作")
                                                                               handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                   [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeMultiSelect];
                                                                                   
                                                                               }];
        editRowAction.backgroundColor = kUIColorFromRGB(0x7F7F7F);
        
        [arr addObject:editRowAction];
    }
    
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeGoodCopy)) {
        UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                 title:ML(@"复制\n新增")
                                                                               handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                   [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeGoodCopy];
                                                                                   
                                                                               }];
        editRowAction.backgroundColor = GC.MC;
        
        [arr addObject:editRowAction];
    }
    
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeEdit)) {
        UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                 title:ML(@"编辑")
                                                                               handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                   [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeEdit];
                                                                                   
                                                                               }];
        editRowAction.backgroundColor = kUIColorFromRGB(0xC0C0C0);
        
        [arr addObject:editRowAction];
    }
    
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeWeChatShare)) {
        UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                 title:ML(@"微信\n分享")
                                                                               handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                   [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeWeChatShare];
                                                                                   
                                                                               }];
        editRowAction.backgroundColor = kUIColorFromRGB(0x2EB82F);
        
        [arr addObject:editRowAction];
    }
    
    if (oneModel && (oneModel.cellEditType & GeneralCellEditTypeShare)) {
        UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                 title:ML(@"分享")
                                                                               handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                   [weakSelf doFromEditModel:oneModel Type:GeneralCellEditTypeShare];
                                                                                   
                                                                               }];
        editRowAction.backgroundColor = kUIColorFromRGB(0x2EB82F);
        
        [arr addObject:editRowAction];
    }
    
    return arr;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

// 加速开始的时候开始执行
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
