//
//  MLWebView.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/30.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "MLWebView.h"
#import "Macro.h"

@interface MLWebView()<WKNavigationDelegate,WKScriptMessageHandler>
{
    NSMutableURLRequest *webRequest;
    WKWebViewConfiguration *wkConfig;
    
    NSArray *configArray;
    NSMutableDictionary *headers;
}

@property (nonatomic, copy  )   WKWebView *wkWebView;

@property (nonatomic, copy  )   UIActivityIndicatorView *loadingView;

@end

@implementation MLWebView

- (void)dealloc
{
    [wkConfig.userContentController removeAllUserScripts];
    _wkWebView.navigationDelegate = nil;
}

#pragma -mark init
- (instancetype)initWithConfig:(NSArray *)jsArray frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        configArray = jsArray;
        headers = [NSMutableDictionary dictionary];
        
        _title = @"";
        _url = @"";
        _userAgent = @"";
        wkConfig = [[WKWebViewConfiguration alloc] init];
        _loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [self initWeb:frame];
    }
    return self;
}

- (void)initWeb:(CGRect)frame
{
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    for (NSString *jsName in configArray) {
        [userContentController addScriptMessageHandler:self name:ML_STRING_FORMAT(jsName)];
    }
    wkConfig.userContentController = userContentController;
    
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) configuration:wkConfig];
    _wkWebView.navigationDelegate = self;
    [self addSubview:_wkWebView];
    
    _loadingView.center = _wkWebView.center;
    [self addSubview:_loadingView];
}

#pragma -mark setter
- (void)setUserAgent:(NSString *)userAgent
{
    _userAgent = userAgent;
    if (@available(iOS 12.0, *)){
        NSString *baseAgent = [_wkWebView valueForKey:@"applicationNameForUserAgent"];
        NSString *userAgent = [NSString stringWithFormat:@"%@ %@",baseAgent,_userAgent];
        [_wkWebView setValue:userAgent forKey:@"applicationNameForUserAgent"];
    }
    [_wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSString *newUA = [NSString stringWithFormat:@"%@ %@",result,self->_userAgent];
        self->_wkWebView.customUserAgent = newUA;
    }];
}

- (void)setUrl:(NSString *)url
{
    NSString *urlString = [url stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    _url = urlString;
}

- (void)setHeaderParams:(NSDictionary *)headerParams
{
    _headerParams = headerParams;
    [headers setValuesForKeysWithDictionary:_headerParams];
}

#pragma mark - webView加载
- (void)loadUrl
{
    if (_url && _url.length > 0)
    {
        webRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
        NSArray *headerKeys = headers.allKeys;
        for (NSInteger i=0;i<headerKeys.count;i++) {
            NSString *key = ML_STRING_FORMAT(headerKeys[i]);
            NSString *value = ML_STRING_FORMAT(headers[key]);
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
    decisionHandler(WKNavigationActionPolicyAllow);
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
    if (_jsActionBlock) {
        _jsActionBlock(ML_STRING_FORMAT(message.name),message.body);
    }
}

#pragma -mark 方法
- (void)startLoading
{
    [_loadingView startAnimating];
    _loadingView.hidden = NO;
}

- (void)stopLoding
{
    [_loadingView stopAnimating];
    _loadingView.hidden = YES;
}

- (UIViewController *)findViewController
{
    id target=self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]])
            break;
    }
    return target;
}

- (void)popViewController{
    [[self findViewController].navigationController popViewControllerAnimated:YES];
}

- (void)popRootViewController{
    [[self findViewController].navigationController popToRootViewControllerAnimated:YES];
}

- (void)goWebHistory{
    if ([_wkWebView canGoBack]) {
        [_wkWebView goBack];
    }
    else{
        [self popViewController];
    }
}

@end
