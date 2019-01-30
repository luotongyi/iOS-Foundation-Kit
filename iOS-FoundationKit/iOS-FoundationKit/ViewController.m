//
//  ViewController.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/28.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "ViewController.h"
#import "MLWebView.h"
#import "MLHTTPRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testAddButton];
    
}

- (void)testAddButton
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(220, 330, 50, 50)];
    [btn addTarget:self action:@selector(testNetwork) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}

- (void)testLoadWeb
{
    MLWebView *bv = [[MLWebView alloc] initWithConfig:@[] frame:CGRectMake(0, 0, 200, 300)];
    [self.view addSubview:bv];
    bv.url = @"http://www.baidu.com";
    [bv loadUrl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self testLoadWeb];
    
}

- (void)testNetwork
{
    NSLog(@"TestNetwork");
    MLRequestItem *item = [[MLRequestItem alloc]init];
    item.serverUrl = @"http://wwwfslfs.cidfjasd.com";
    item.requestMethod = MLHTTP_GET;
    item.requestParams = @{@"aa":@"dfsdf",
                           @"bb":@"fasdfasd",
                           @"cc":@"fasdfasdfa"};
    [MLHTTPRequest requestItem:item successBlock:^(id responseObject) {
        
    } failureBlock:^(id errorObject) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
