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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*
    [[XYRouter shared] openUrl:@"a/b"];
    
    [[XYRouter shared] openUrl:@"/a/b"];
    
    [[XYRouter shared] openUrl:@"./a/b"];
    
    [[XYRouter shared] openUrl:@"../a/b"];
    
    [[XYRouter shared] openUrl:@"/c./d"];
    
    [[XYRouter shared] openUrl:@"www.baidu.com/a/b/c.php"];
    */
    
    [[XYRouter sharedInstance] mapKey:@"aaa" toControllerClassName:@"UIViewController"];
    
    NSNumber *n = [NSNumber numberWithDouble:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
