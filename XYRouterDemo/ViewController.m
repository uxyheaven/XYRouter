//
//  ViewController.m
//  XYRouter
//
//  Created by heaven on 15/1/21.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "ViewController.h"
#import "XYRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [[XYRouter sharedInstance] mapKey:@"aaa" toControllerClassName:@"UIViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
