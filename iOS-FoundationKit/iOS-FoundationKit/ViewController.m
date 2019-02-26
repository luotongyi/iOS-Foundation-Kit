//
//  ViewController.m
//  iOS-FoundationKit
//
//  Created by luoty on 2019/1/28.
//  Copyright © 2019年 luoty. All rights reserved.
//

#import "ViewController.h"
#import "MLWebController.h"
#import "MLHTTPRequest.h"
#import "MLInfoUtility.h"
#import "MLSqliteModel.h"

#import "MLSystemKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testHookButton];
    
    MLSqliteModel *model = [MLSqliteModel new];
    
    NSLog(@"%@",model.timestamp);
    NSLog(@"%@",[MLInfoUtility getUUID]);
    
//    MLSystemKit *kit = [[MLSystemKit alloc]init];
    [MLSystemKit registeNotification];
}

- (void)testHookButton
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(220, 330, 50, 50)];
    [btn addTarget:self action:@selector(testNetwork) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}

#define ML_WEAK_SELF1(weakSelf1)(obj)        __weak __typeof(&*obj)weakSelf1 = obj;

- (void)testLoadWeb
{
    MLWebController *controller = [MLWebController new];
    __weak __typeof(&*controller)weakSelf = controller;
    controller.jsNamesArray = @[@"name1",@"name2"];
    
    [controller setJsCallNativeBlock:^(NSString *name, id body) {
        if ([name isEqualToString:@"name1"]) {
            [weakSelf handleJS:@""];
        }
        else{
            
        }
    }];
    [controller setEvaluateJSBlock:^(id response) {
        
    }];
    controller.url = @"https://itunes.apple.com/cn/app//id847285955?mt=8";
    [self.navigationController pushViewController:controller animated:YES];
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
