//
//  TestVC1.h
//  XYRouter
//
//  Created by heaven on 15/6/4.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYRouter.h"

@interface TestVC1 : UIViewController<XYRouteViewControllerProtocol>

@property (nonatomic, assign) NSInteger i;
@property (nonatomic, copy) NSString *str1;
@property (nonatomic, copy) NSString *str2;

+ (UIViewController *)uxy_showedViewController;

@end
