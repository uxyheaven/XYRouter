//
//  UIViewController+nvcItem.m
//  XYRouter
//
//  Created by Heaven on 15/8/17.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "UIViewController+nvcItem.h"
#import "XYRouter.h"

@implementation UIViewController (nvcItem)

- (void)addRightBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(clickCompose)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)addPathButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 60, 200, 50);
    [btn setTitle:@"show path" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickCompose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)clickCompose
{
    NSString *str = [XYRouter sharedInstance].currentPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
    [alert show];
}

- (NSString *)description
{
    NSString *str = [super description];
    str = [NSString stringWithFormat:@"%@", self.uxy_URLPath];
    return str;
}
@end
