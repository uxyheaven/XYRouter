//
//  TestVC1.h
//  XYRouter
//
//  Created by heaven on 15/6/4.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

// 这是一个带有参数的viewController
@interface TestVC1 : UIViewController

@property (nonatomic, assign) NSInteger i;
@property (nonatomic, copy) NSString *str1;
@property (nonatomic, copy) NSString *str2;

+ (instancetype)viewControllerWithStr1:(NSString *)str1 str2:(NSString *)str2;

@end
