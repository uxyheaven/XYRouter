//
//  ViewController+nvcItem.m
//  XYRouter
//
//  Created by Heaven on 15/8/17.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "ViewController+nvcItem.h"
#import "XYRouter.h"

@implementation UIViewController (nvcItem)

- (void)addRightBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(clickCompose)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)clickCompose
{
    NSString *str = [XYRouter sharedInstance].currentPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
    [alert show];
}
@end
