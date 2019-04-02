//
//  KPWKWebViewVC.m
//  kp
//
//  Created by gzkp on 2018/9/27.
//  Copyright © 2018年 kptech. All rights reserved.
//

#import "KPWKWebViewVC.h"
#import "NavigationView.h"
#import <WebKit/WebKit.h>
#import "GeneralConfig.h"
#import "GMUtils+HUD.h"
#import <KPFoundation/KPFoundation.h>

@interface KPWKWebViewVC ()

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic,strong) NavigationView *naviView;

@end

@implementation KPWKWebViewVC

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect webViewFrame = CGRectMake(0, GC.topBarNowHeight+GC.navBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    if (_isPresent) {
        // 创建自定义Navi
        NavigationView *naviView = [[NavigationView alloc]init];
        _naviView = naviView;
        naviView.titleLabel.text = self.title;
        [self.view addSubview:naviView];
        webViewFrame = CGRectMake(0, naviView.frame.size.height, self.view.frame.size.width, SCREEN_HEIGHT-naviView.frame.size.height);
        
        if (_rightBtnText && _rightBtnText.length) {
            [naviView.rightBtn setTitle:_rightBtnText forState:UIControlStateNormal];
            [naviView.rightBtn addTarget:self action:@selector(clickRightAction:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        [naviView.leftBtn addTarget:self action:@selector(clickLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        
        
    }
    
    self.webView = [[WKWebView alloc]initWithFrame:webViewFrame];
//    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - delegate
- (void)webViewDidStartLoad:(WKWebView *)webView
{
    [GMUtils showWaitingHUDInView:self.view];
}

- (void)webViewDidFinishLoad:(WKWebView *)webView
{
    [GMUtils hideAllWaitingHudInView:self.view];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1)
        {
            
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
             }
                             completion:^(BOOL finished)
             {
                 self.progressView.hidden = YES;
             }];
        }
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if(error.code==NSURLErrorCancelled)
    {
        [self webView:webView didFinishNavigation:navigation];
    }
    else
    {
        self.progressView.hidden = YES;
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    self.progressView.hidden = YES;
    [GMUtils showQuickTipWithText:ML(@"加载失败")];
}


#pragma mark - action
- (void)clickRightAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.simpleDelegate && [self.simpleDelegate respondsToSelector:@selector(webViewClickRightBtn)]) {
        [self.simpleDelegate webViewClickRightBtn];
    }
    
}

- (void)clickLeftAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_webType == WebViewForViewClause) {

    }
}

#pragma mark - alloc
- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
        _progressView.backgroundColor = GC.CBlack;
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        _progressView.progressTintColor = GC.MC;
        [self.webView addSubview:_progressView];
    }
    return _progressView;
}



@end
