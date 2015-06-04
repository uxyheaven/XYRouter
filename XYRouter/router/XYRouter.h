//
//  XYRouter.h
//  XYRouter
//
//  Created by heaven on 15/1/21.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol XYRouteProtocol <NSObject>

- (void)gotoBack;     // 返回上一个
- (void)gotoRoot;     // 返回根
- (void)gotoCurrent;  // 打开自己的方法

- (UIViewController *)backViewController;

@end


typedef UIViewController *(^XYRouterBlock)();

@interface XYRouter : NSObject

+ (instancetype)sharedInstance;

- (void)mapKey:(NSString *)key toControllerClassName:(NSString *)className;
- (void)mapKey:(NSString *)key toControllerInstance:(UIViewController *)viewController;
- (void)mapKey:(NSString *)key toBlock:(XYRouterBlock)block;

- (id)viewControllerForKey:(NSString *)key;

//- (void)openUrl:(NSString *)strUrl;

@end

#pragma mark -
@interface UIViewController (XYRouter)

- (void)uxy_pushViewController:(UIViewController *)viewController
                        params:(id)params
                      animated:(BOOL)flag
                    completion:(void (^)(void))completion;

- (void)uxy_popViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion;

@end