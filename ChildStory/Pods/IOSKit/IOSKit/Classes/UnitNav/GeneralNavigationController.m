//
//  GeneralNavigationController.m
//  Expecta
//
//  Created by zhang yyuan on 2018/7/5.
//

#import "GeneralNavigationController.h"

@interface GeneralNavigationController ()

@end

@implementation GeneralNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.translucent = NO;
        
        if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
            rootViewController.automaticallyAdjustsScrollViewInsets = YES;
            rootViewController.edgesForExtendedLayout = UIRectEdgeNone;
            rootViewController.extendedLayoutIncludesOpaqueBars = NO;
            rootViewController.modalPresentationCapturesStatusBarAppearance = NO;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
