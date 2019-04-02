//
//  PhotoNavigationController.m
//  Expecta
//
//  Created by zhang yyuan on 2018/7/5.
//

#import "PhotoNavigationController.h"

#import "ZLDefine.h"
#import "ZLPhotoConfiguration.h"
#import "ZLPhotoModel.h"

@interface PhotoNavigationController ()

/**
 相册框架配置
 */
@property (nonatomic, strong) ZLPhotoConfiguration *configuration;

@end

@implementation PhotoNavigationController

- (instancetype)initConfiguration:(id)conf Root:(id)rvc
{
    self = [super initWithRootViewController:rvc];
    if (self) {
        if (conf && [conf isKindOfClass:[ZLPhotoConfiguration class]]) {
            _configuration = conf;
            
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray<ZLPhotoModel *> *)arrSelectedModels
{
    if (!_arrSelectedModels) {
        _arrSelectedModels = [NSMutableArray array];
    }
    return _arrSelectedModels;
}

- (id)getConfiguration {
    return _configuration;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
