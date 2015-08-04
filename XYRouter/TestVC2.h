//
//  TestVC2.h
//  XYRouter
//
//  Created by heaven on 15/7/23.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYRouter.h"

// 这是一个符合XYRouteViewControllerProtocol协议, 带有导航的viewController
@interface TestVC2 : UIViewController<XYRouteViewControllerProtocol>
+ (UIViewController *)uxy_showedViewController;
@end
