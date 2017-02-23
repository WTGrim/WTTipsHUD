//
//  ViewController.m
//  WTTipsHUD
//
//  Created by Dwt on 2017/2/17.
//  Copyright © 2017年 Dwt. All rights reserved.
//

#import "ViewController.h"

#import "WTTipsHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 115, 125);
    [button setTitle:@"点点" forState:UIControlStateNormal];
    [button addTarget: self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(100, 400, 115, 125);
    [button1 setTitle:@"测试按钮" forState:UIControlStateNormal];
    [button1 addTarget: self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
}


- (void)show{
    
    [WTTipsHUD showLoadingMessage:@"加载中..." duration:4];
//    [WTTipsHUD showMessage:@"神兽保佑代码无bug  神兽啊神兽你去了哪里我怎么找不到你了" duration:4];
//    [WTTipsHUD showErrorHUD:@"神兽你在哪儿" duration:4];
//    [WTTipsHUD showSuccessHUD:@"神兽" duration:4];
//    [WTTipsHUD showCircleLoaingMessage:@"神兽保佑啊神兽"];
//    [WTTipsHUD showCircleLoaingMessage:@""];
}

- (void)test{
    
    NSLog(@"测试按钮被点击了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
