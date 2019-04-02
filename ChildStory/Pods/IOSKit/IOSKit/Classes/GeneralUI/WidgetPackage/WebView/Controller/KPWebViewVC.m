//
//  KPWebViewVC.m
//  kp
//
//  Created by gzkp on 2017/11/9.
//  Copyright © 2017年 kptech. All rights reserved.
//

#import "KPWebViewVC.h"
#import "GeneralConfig.h"
#import "GMUtils+HUD.h"

@interface KPWebViewVC ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;


@end

@implementation KPWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCookie];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, GC.navBarHeight+GC.topBarNormalHeight, SCREEN_WIDTH, SCREEN_HEIGHT-(GC.navBarHeight+GC.topBarNormalHeight))];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
    });
    
    
    
    
}

- (void)setCookie{
    
    NSURL *url = [NSURL URLWithString:_url];
    {
        NSDictionary *properties = [[NSMutableDictionary alloc] init];
        [properties setValue:[url host] forKey:NSHTTPCookieDomain];
        [properties setValue:@"/" forKey:NSHTTPCookiePath];
        [properties setValue:@"account_id_2" forKey:NSHTTPCookieName];
        [properties setValue:_account_id forKey:NSHTTPCookieValue];
        
        NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
  
    {
        NSDictionary *properties = [[NSMutableDictionary alloc] init];
        [properties setValue:[url host] forKey:NSHTTPCookieDomain];
        [properties setValue:@"/" forKey:NSHTTPCookiePath];
        [properties setValue:@"big_token_2" forKey:NSHTTPCookieName];
        [properties setValue:_bigToken forKey:NSHTTPCookieValue];
        
        NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
    {
        NSDictionary *properties = [[NSMutableDictionary alloc] init];
        [properties setValue:[url host] forKey:NSHTTPCookieDomain];
        [properties setValue:@"/" forKey:NSHTTPCookiePath];
        [properties setValue:@"token_2" forKey:NSHTTPCookieName];
        [properties setValue:_token forKey:NSHTTPCookieValue];
        
        NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [GMUtils showWaitingHUDInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [GMUtils hideAllWaitingHudInView:self.view];
}

- (void)deleteCookie{
    
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookieAry = [cookieJar cookiesForURL: [NSURL URLWithString: _url]];
    
    for (cookie in cookieAry) {
        
        [cookieJar deleteCookie: cookie];
        
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

@end
