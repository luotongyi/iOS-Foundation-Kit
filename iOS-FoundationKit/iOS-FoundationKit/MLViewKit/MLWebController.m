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

@property (nonatomic, strong)   UIProgressView *myProgressView;
@property (nonatomic, strong)   UIActivityIndicatorView *defaultLoadingView;

@end

@implementation MLWebController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _url = @"";
        _userAgent = @"";
        _jsNamesArray = @[@"AIOpenWebPage",
                          @"AIWebGoback",
                          @"AIWebRefresh",
                          @"AIWebClose",
                          @"AIScanner",
                          @"AILocation",
                          @"AIShake",
                          @"AITakePhoto",
                          @"AIFaceRecognition",
                          @"AIOpenPaperlessPage",
                          @"AIBluetoothConnect",
                          @"AIReadIDCard",
                          @"AIReadSIMCard",
                          @"AIWriteSIMCard"];
        _headerParams = @{};
        
        jsArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [jsArray addObjectsFromArray:_jsNamesArray];
    
    [self createWebView];
    [self createLoadingView];
    
    _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, ML_SCREEN_WIDTH, 0)];
    _myProgressView.progressTintColor = [UIColor blueColor];
    _myProgressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:_myProgressView];
    
    [self loadUrl];
    
    [self createBarItems];
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
    
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ML_SCREEN_WIDTH, ML_SCREEN_HEIGHT) configuration:wkConfig];
    _wkWebView.navigationDelegate = self;
    [self.view addSubview:_wkWebView];
    
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    ML_WEAK_SELF(weakSelf)
    if (@available(iOS 12.0, *)){
        NSString *baseAgent = [_wkWebView valueForKey:@"applicationNameForUserAgent"];
        NSString *userAgent = [NSString stringWithFormat:@"%@ %@",baseAgent,_userAgent];
        [_wkWebView setValue:userAgent forKey:@"applicationNameForUserAgent"];
    }
    [_wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSString *newUA = [NSString stringWithFormat:@"%@ %@",result,weakSelf.userAgent];
        if (@available(iOS 9.0, *)){
            weakSelf.wkWebView.customUserAgent = newUA;
        }
    }];
}

#pragma mark - event response
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.myProgressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.myProgressView setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 加载返回、刷新按钮
- (void)createBarItems
{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [backBtn addTarget:self action:@selector(goWebHistory) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [closeBtn addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
    
    //适配iOS 11
    if (@available(iOS 11.0,*)) {
        [backBtn setContentMode:UIViewContentModeScaleToFill];
        [backBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 5, 20)];
        
        [closeBtn setContentMode:UIViewContentModeScaleToFill];
        [closeBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 5, 20)];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:closeBtn];
}

#pragma -mark 加载等待框
- (void)createLoadingView
{
    _defaultLoadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_defaultLoadingView];
    _defaultLoadingView.center = self.view.center;
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

#pragma -mark dealloc
- (void)dealloc
{
    for (NSString *jsName in jsArray) {
        [wkConfig.userContentController removeScriptMessageHandlerForName:ML_STRING_FORMAT(jsName)];
    }
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    _wkWebView.navigationDelegate = nil;
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
            if (!_headerParams || [_headerParams isKindOfClass:[NSString class]]) {
                _headerParams = @{};
            }
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
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [webView reload];
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
    [self jsCallNativeAction:ML_STRING_FORMAT(message.name) body:message.body];
}

- (void)jsCallNativeAction:(NSString *)name body:(NSDictionary *)body
{
    NSLog(@"%@----%@",name,body);
    if ([name isEqualToString:@"AIOpenWebPage"]) {
        //打开webController
        [self pushWebPage:body];
    }
    else if ([name isEqualToString:@"AIWebGoback"]) {
        //webController返回历史记录
        [self goWebHistory];
    }
    else if ([name isEqualToString:@"AIWebRefresh"]) {
        //刷新web界面
        [self refresh];
    }
    else if ([name isEqualToString:@"AIWebClose"]) {
        //关闭web界面
        [self popController];
    }
    else if ([name isEqualToString:@"AIScanner"]) {
        //拉起二维码扫描界面
        //AIScannerCallback
        
    }
    else if ([name isEqualToString:@"AILocation"]) {
        //调用定位功能
        //AILocationCallback
        
    }
    else if ([name isEqualToString:@"AIShake"]) {
        //摇一摇获取定位信息
        //AIShakeCallback
        
    }
    else if ([name isEqualToString:@"AITakePhoto"]) {
        //拍照
        //AITakePhotoCallback
        
    }
    else if ([name isEqualToString:@"AIFaceRecognition"]) {
        //人脸识别
        
    }
    else if ([name isEqualToString:@"AIOpenPaperlessPage"]) {
        //无纸化
        
    }
    else if ([name isEqualToString:@"AIBluetoothConnect"]) {
        //蓝牙连接，集成第三方的读写卡、身份证读取盒子之后的调用
        
    }
    else if ([name isEqualToString:@"AIReadIDCard"]) {
        //读取身份证
        //AIReadIDCardCallback
        
    }
    else if ([name isEqualToString:@"AIReadSIMCard"]) {
        //读取SIM卡信息
        //AIReadSIMCardCallback
        
    }
    else if ([name isEqualToString:@"AIWriteSIMCard"]) {
        //写SIM卡
        //AIWriteSIMCardCallback
        
    }
    else{
        
    }
}

#pragma -mark js-call-native 方法
- (void)pushWebPage:(NSDictionary *)body
{
    MLWebController *controller = [MLWebController new];
    controller.url = ML_STRING_FORMAT(body[@"url"]);
    controller.userAgent = self.userAgent;
    controller.headerParams = self.headerParams;
    controller.jsNamesArray = jsArray;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goWebHistory{
    if ([_wkWebView canGoBack]) {
        [_wkWebView goBack];
    }
    else {
        [self popController];
    }
}

- (void)popRootController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)popController
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)handleJS:(NSString *)js
{
    [_wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
    }];
}



@end
