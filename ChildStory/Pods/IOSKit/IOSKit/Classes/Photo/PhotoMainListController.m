//
//  PhotoMainListController.m
//  Expecta
//
//  Created by zhang yyuan on 2018/7/5.
//

#import "PhotoMainListController.h"

#import "PhotoNavigationController.h"

#import "PhotoSelectController.h"

#import "ZLPhotoManager.h"
#import "ZLPhotoConfiguration.h"

#import <IOSKit/IOSKit.h>
#import <KPFoundation/KPFoundation.h>

@interface PhotoMainListController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *photoTable;
}

@property (nonatomic, strong) NSMutableArray<ZLAlbumListModel *> *arrayDataSources;

@end

@implementation PhotoMainListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    photoTable = [[UITableView alloc] initWithFrame:[self getShowScreen] style:UITableViewStylePlain];
    [photoTable setBackgroundColor:GC.BG];
    photoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    photoTable.dataSource = self;
    photoTable.delegate = self;
    
    [self.view addSubview:photoTable];
    
    [self initNavBtn];
    
    if (@available(iOS 11.0, *)) {
        [photoTable setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
        zl_weakify(self);
        [ZLPhotoManager getPhotoAblumList:configuration.allowSelectVideo allowSelectImage:configuration.allowSelectImage complete:^(NSArray<ZLAlbumListModel *> *albums) {
            zl_strongify(weakSelf);
            strongSelf.arrayDataSources = [NSMutableArray arrayWithArray:albums];
            dispatch_async(dispatch_get_main_queue(), ^{
                [photoTable reloadData];
            });
        }];
    });
}

- (void)initNavBtn
{
    self.title = ML(@"全部");
    
    [self addRightBarButtonItem:ML(@"取消")];
}

- (void)navRightBtn_Click
{
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    if (nav.cancelBlock) {
        nav.cancelBlock();
    }
    [nav dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayDataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZLPhotoBrowserCell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZLPhotoBrowserCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 55, 55)];
        [headImageView setTag:100];
        [headImageView setBackgroundColor:[UIColor clearColor]];
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius = 4;
        [cell addSubview:headImageView];
        
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 250, 65)];
        [labTitle setTag:101];
        [labTitle setFont:[UIFont systemFontOfSize:16]];
        [cell addSubview:labTitle];
        
    }
    
    __block UIImageView *headImageView = [cell viewWithTag:100];
    UILabel *labTitle = [cell viewWithTag:101];
    
    headImageView.image = nil;
    
    ZLPhotoConfiguration *configuration = [(PhotoNavigationController *)self.navigationController getConfiguration];
    ZLAlbumListModel *albumModel = self.arrayDataSources[indexPath.row];
    
    albumModel.headImageAsset.localIdentifier;
    [ZLPhotoManager requestImageForAsset:albumModel.headImageAsset size:CGSizeMake(GetViewHeight(headImageView)*2.5, GetViewHeight(headImageView)*2.5) completion:^(UIImage *image, NSDictionary *info) {
        headImageView.image = image;
    }];
    
    [labTitle setText:[NSString stringWithFormat:@"%@(%ld)" ,albumModel.title ,albumModel.count]] ;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushThumbnailVCWithIndex:indexPath.row animated:YES];
}

- (void)pushThumbnailVCWithIndex:(NSInteger)index animated:(BOOL)animated
{
    ZLAlbumListModel *model = self.arrayDataSources[index];
    
    PhotoSelectController *tvc = [[PhotoSelectController alloc] init];
    tvc.selectPhotoType = self.selectPhotoType;
    tvc.albumListModel = model;
    
    [self.navigationController showViewController:tvc sender:self];
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

- (void)rightBarButtonItemClicked:(UIBarButtonItem *)barButtonItem
{
    PhotoNavigationController *nav = (PhotoNavigationController *)self.navigationController;
    if (nav.cancelBlock) {
        nav.cancelBlock();
    }
    [nav dismissViewControllerAnimated:YES completion:nil];
}


@end

