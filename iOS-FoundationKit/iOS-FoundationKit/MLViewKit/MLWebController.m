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
    
    NSMutableArray *jsArray;
}

@property (nonatomic, strong)   WKWebView *wkWebView;

@property (nonatomic, strong)   UIActivityIndicatorView *defaultLoadingView;

@end

@implementation MLWebController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _url = @"";
        _userAgent = @"";
        _jsNamesArray = @[];
        _headerParams = @{};
        
        jsArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [jsArray addObjectsFromArray:_jsNamesArray];
    
    [self createWebView];
    [self createLoadingView];
    
    [self loadUrl];
}

#pragma -mark 初始化wkWebView
- (void)createWebView
{
    wkConfig = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    for (NSString *jsName in jsArray) {
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
    NSString *urlString = [_url stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    _url = urlString;
    
    if (_url && _url.length > 0)
    {
        if (![_url hasPrefix:@"http"]) {
            [self loadLocalHtml:_url];
        }
        else{
            webRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
            NSArray *headerKeys = _headerParams.allKeys;
            for (NSString *key in headerKeys) {
                NSString *value = ML_STRING_FORMAT(_headerParams[key]);
                [webRequest setValue:value forHTTPHeaderField:key];
            }
            [_wkWebView loadRequest:webRequest];
        }
    }
}

- (void)loadLocalHtml:(NSString *)fileName
{
    NSString *fullFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSError* error = nil;
    NSURL* fileURL = [NSURL fileURLWithPath:fullFilePath];
    NSString* html = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    [_wkWebView loadHTMLString: html baseURL: fileURL];
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
        if ([urlString hasSuffix:@".html"]) {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
        else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            });
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
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
    controller.jsNamesArray = [NSArray arrayWithArray:jsArray];
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
    if (!_loadingView) {
        [_defaultLoadingView startAnimating];
        _defaultLoadingView.hidden = NO;
    }
    else{
        
    }
}

- (void)stopLoding
{
    if (!_loadingView) {
        [_defaultLoadingView stopAnimating];
        _defaultLoadingView.hidden = YES;
    }
    else{
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    for (NSString *jsName in jsArray) {
        [wkConfig.userContentController removeScriptMessageHandlerForName:ML_STRING_FORMAT(jsName)];
    }
    _wkWebView.navigationDelegate = nil;
}


@end
