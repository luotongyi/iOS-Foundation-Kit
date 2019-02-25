//
//  MLWebController.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/2/25.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLWebController.h"
#import <WebKit/WebKit.h>
#import "Macro.h"

@interface MLWebController ()<WKNavigationDelegate,WKScriptMessageHandler>
{
    NSMutableURLRequest *webRequest;
    WKWebViewConfiguration *wkConfig;
}

@property (nonatomic, strong)   WKWebView *wkWebView;

@property (nonatomic, strong)   UIActivityIndicatorView *defaultLoadingView;

@end

@implementation MLWebController

- (void)errorHandler
{
    if (!_url) {
        _url = @"";
    }
    if (!_userAgent) {
        _userAgent = @"";
    }
    if (!_jsNamesArray) {
        _jsNamesArray = @[];
    }
    if (!_headerParams) {
        _headerParams = @{};
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self errorHandler];
    
    [self createWebView];
    [self createLoadingView];
    
    [self loadUrl];
}

- (void)setUrl:(NSString *)url
{
    NSString *urlString = [url stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    _url = urlString;
}

#pragma -mark 初始化wkWebView
- (void)createWebView
{
    wkConfig = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    for (NSString *jsName in _jsNamesArray) {
        [userContentController addScriptMessageHandler:self name:ML_STRING_FORMAT(jsName)];
    }
    wkConfig.userContentController = userContentController;
    
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-10) configuration:wkConfig];
    _wkWebView.navigationDelegate = self;
    [self.view addSubview:_wkWebView];
    
    ML_WEAK_SELF(weakSelf)
    if (@available(iOS 12.0, *)){
        NSString *baseAgent = [_wkWebView valueForKey:@"applicationNameForUserAgent"];
        NSString *userAgent = [NSString stringWithFormat:@"%@ %@",baseAgent,_userAgent];
        [_wkWebView setValue:userAgent forKey:@"applicationNameForUserAgent"];
    }
    [_wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSString *newUA = [NSString stringWithFormat:@"%@ %@",result,weakSelf.userAgent];
        weakSelf.wkWebView.customUserAgent = newUA;
    }];
}

#pragma -mark web请求
- (void)loadUrl
{
    if (_url && _url.length > 0)
    {
        webRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
        NSArray *headerKeys = _headerParams.allKeys;
        for (NSString *key in headerKeys) {
            NSString *value = ML_STRING_FORMAT(_headerParams[key]);
            [webRequest setValue:value forHTTPHeaderField:key];
        }
        [_wkWebView loadRequest:webRequest];
    }
}

- (void)refresh
{
    [self loadUrl];
}

#pragma mark - WKWebview
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlString = navigationAction.request.URL.absoluteString;
    if (![urlString hasPrefix:@"http"] || [urlString hasPrefix:@"https://itunes.apple.com"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            });
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else{
        if (_pushNewPage) {
            [self pushNewController:urlString];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self startLoading];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    [self stopLoding];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self stopLoding];
    if(error.code == NSURLErrorCancelled)  {
        return;
    }
    if (error.code == NSURLErrorUnsupportedURL) {
        return;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self stopLoding];
    self.title = webView.title;
}

#pragma mark - 加载JS处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (_jsCallNativeBlock) {
        _jsCallNativeBlock(ML_STRING_FORMAT(message.name),message.body);
    }
}

#pragma -mark 方法
- (void)pushNewController:(NSString *)actionUrl
{
    ML_WEAK_SELF(weakSelf);
    MLWebController *controller = [MLWebController new];
    controller.url = actionUrl;
    controller.jsNamesArray = [_jsNamesArray mutableCopy];
    controller.headerParams = [_headerParams mutableCopy];
    controller.userAgent = [_userAgent mutableCopy];
    controller.pushNewPage = _pushNewPage;
    controller.loadingView = [_loadingView mutableCopy];
    controller.loadingFailView = [_loadingFailView mutableCopy];
    [controller setJsCallNativeBlock:^(NSString *name, id body) {
        if (weakSelf.jsCallNativeBlock) {
            weakSelf.jsCallNativeBlock(name,body);
        }
    }];
    [controller setEvaluateJSBlock:^(id response) {
        if (weakSelf.evaluateJSBlock) {
            weakSelf.evaluateJSBlock(response);
        }
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)popController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popRootController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goWebHistory{
    if ([_wkWebView canGoBack]) {
        [_wkWebView goBack];
    }
    else{
        [self popController];
    }
}

- (void)handleJS:(NSString *)js
{
    ML_WEAK_SELF(weakSelf)
    [_wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (weakSelf.evaluateJSBlock) {
            weakSelf.evaluateJSBlock(response);
        }
    }];
}

#pragma -mark 加载等待框
- (void)createLoadingView
{
    if (!_loadingView) {
        _defaultLoadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:_defaultLoadingView];
        _defaultLoadingView.center = self.view.center;
    }
    else{
        [self.view addSubview:_loadingView];
        _loadingView.center = self.view.center;
    }
}

- (void)startLoading
{
    [_defaultLoadingView startAnimating];
    _defaultLoadingView.hidden = NO;
}

- (void)stopLoding
{
    [_defaultLoadingView stopAnimating];
    _defaultLoadingView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    for (NSString *jsName in _jsNamesArray) {
        [wkConfig.userContentController removeScriptMessageHandlerForName:ML_STRING_FORMAT(jsName)];
    }
    _wkWebView.navigationDelegate = nil;
}


@end