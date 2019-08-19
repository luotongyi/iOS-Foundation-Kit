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

#import "MLAuthority.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
    });
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    
    [MLAuthority checkAuthority:MLPhotoLibrary complete:^(BOOL result) {
        
    }];
    
    
//    [self testHookButton];
//
//    MLSqliteModel *model = [MLSqliteModel new];
//
//    NSLog(@"%@",model.timestamp);
//    NSLog(@"%@",[MLInfoUtility getUUID]);
//
////    MLSystemKit *kit = [[MLSystemKit alloc]init];
//    [MLSystemKit registeNotification];
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
//    __weak __typeof(&*controller)weakSelf = controller;
    controller.jsNamesArray = @[@"showLog"];
    [controller setJsCallNativeBlock:^(NSString *name, id body) {
        if ([name isEqualToString:@"showLog"]) {
            NSLog(@"%@-\n-%@",name,body);
        }
        else if ([name isEqualToString:@"name1"]){
            //自己先做一些列想要的操作

            // ...

            //然后手动调用js
//            NSString *testJs = [NSString stringWithFormat:@"writeCardCallback('%@');",@"fdsfsdf"];
//            [weakSelf handleJS:testJs];
        }
        else{

        }
    }];
//    [controller setEvaluateJSBlock:^(id response) {
//
//    }];
    controller.url = @"index.html";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)testAAAA
{
    
}

- (void)name1
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"执行了首页方法");
//    [self testLoadWeb];
}

- (void)testNetwork
{
    [self testLoadWeb];
    
    NSLog(@"TestNetwork");
//    MLRequestItem *item = [[MLRequestItem alloc]init];
//    item.serverUrl = @"http://wwwfslfs.cidfjasd.com";
//    item.requestMethod = MLHTTP_GET;
//    item.requestParams = @{@"aa":@"dfsdf",
//                           @"bb":@"fasdfasd",
//                           @"cc":@"fasdfasdfa"};
//    [MLHTTPRequest requestItem:item successBlock:^(id responseObject) {
//
//    } failureBlock:^(id errorObject) {
//
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
