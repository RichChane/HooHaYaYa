//
//  GeneralTableController+Observer.m
//  IOSKit
//
//  Created by zhang yyuan on 2018/2/23.
//

#import <IOSKit/GeneralTableController+Observer.h>

#import <IOSKit/IOSKit.h>
#import <KPFoundation/KPFoundation.h>

@implementation GeneralTableController (Observer)

- (instancetype)initWithTableType:(NSInteger)type Object:(id)obj{
    return [self initWithTable];
}

- (void)haveData {}
- (void)noData {}
- (void)upMoreData {}
- (void)downMoreData {}

- (void)willLoad{}

- (GeneralViewSection *) createSectionHeadWithModel:(GeneralSectionModel *)f_Model ReuseIdentifier:(NSString *)r_id{    return nil; }
- (GeneralViewSection *) createSectionFootWithModel:(GeneralSectionModel *)f_Model ReuseIdentifier:(NSString *)r_id{    return nil; }

- (GeneralViewCell *) createCellWithFrameModel:(GeneralCellModel *)f_Model ReuseIdentifier:(NSString *)r_id{    return nil; }

- (GeneralToView *) createViewWithModel:(GeneralViewModel *)f_Model {    return nil; }

- (void)registerCell{}

- (void)doFromEditModel:(id)model Type:(GeneralCellEditType)type{}

#pragma mark -TableViewControllerDelegate
- (void)reloadFromCell:(id)msg{}
- (void)productCode:(NSString *)code OtherMsg:(id)oterMsg{}
- (void)changerModelType:(NSInteger)mType{}
- (void)changeRootStaffTo:(id)otherStaff code:(NSString *)code type:(int32_t)type{}
- (void)kickUserStaff:(id)delStaff staffTransfer:(id)staffTransfer{}



///////////////////////////

- (NSString *)getTipWithType{
    return nil;
}

- (BOOL)isSearchToReturnEnd{
    return NO;
}

- (void)buildRecordView{}

- (void)buildNavUI{
    if (isSearch) {
        if (searchView) {
            
        }else{
            
            if ([[UIDevice currentDevice] systemVersion].floatValue >= 11 && !self.isSelfNav) {
                [self addRightBarButtonItem:ML(@"    取消")];
            }else {
                [self addRightBarButtonItem:ML(@"取消") TintColor:[UIColor blackColor]];
            }
            
            if (self.isSelfNav) {
                searchView = [[SearchHandle alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.searchHeight) Tip:searchToTip Delegate:self];
                self.customNavBar.customView = searchView;
            } else {
                searchView = [[SearchHandle alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, self.searchHeight) Tip:searchToTip Delegate:self];
                self.navigationItem.titleView = searchView;
            }
            
            searchView.returnEndSearch = [self isSearchToReturnEnd];
            
            [self addLeftBarButtonItem:nil];
            [self addRight2ButtonItem:nil];
            
            if (self.searchText && [self.searchText length]) {
                [searchView setToSearchText:self.searchText];
            }else{
                if ([searchView canBecomeFirstResponder]) {
                    [searchView becomeFirstResponder];
                }
            }
        }
    }
}

#pragma mark - SearchHandleDelegate
- (void)searchReady{
    [self cleanTable];
}

- (void)searchText:(NSString *)text{
    
    self.searchText = text;
    
    if (!text || [text length] == 0) {
        [self cleanTable];
        
        [self buildRecordView];
    }
}

- (void)searchEnd{
    
    NSLog(@"end");
    
}

@end
