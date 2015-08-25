//
//  TestModalVC.m
//  XYRouterDemo
//
//  Created by Heaven on 15/8/18.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "TestModalVC.h"
#import "UIViewController+nvcItem.h"
#import "XYRouter.h"

@implementation TestModalVC

- (void)dealloc
{
    NSLog(@"%s", __func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"TestModalVC";
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 200, 200, 50);
    label.text = NSStringFromClass([self class]);
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 250, 200, 50);
    [btn setTitle:@"dismiss" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self addRightBarButtonItem];
    [self addPathButton];
    
    NSLog(@"%s, i = %@, str1 = %@, str2 = %@", __func__, @(_i), _str1, _str2);
}

- (void)clickDismiss
{
    [[XYRouter sharedInstance] openURLString:@"dismiss"];
}

@end
