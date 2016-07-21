//
//  XYRouter.h
//  XYRouter
//
//  Created by heaven on 15/1/21.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#undef  __XYROUTER_VERSION__
#define __XYROUTER_VERSION__    "0.7.2" // 主版本号


#pragma mark - define
typedef enum
{
    XYRouteURLType_invalid,                     // 无效
    XYRouteURLType_push,                        // 在当前目录push               : ./
    XYRouteURLType_pushAfterPop,                // 在上一个目录push             : ../
    XYRouteURLType_pushAfterGotoRoot,           // 在根目录根push               : /
    // XYRouteURLType_push,                     // 在当前目录push               : 空
}XYRouteType;

typedef UIViewController *  (^XYRouterBlock)();

#pragma mark - protocol
@class XYRouter;
@protocol XYRouterDelegate <NSObject>

//- (BOOL)xyRouter:(XYRouter *)router shouldFromController:(UIViewController *)from toController:(UIViewController *)to URL:(NSString *)URL;

/// 返回navigationController. 注意,因为时机的问题.目前的版本 from, to 都是没有值的.
- (UINavigationController *)xyRouter:(XYRouter *)router navigationControllerFromController:(UIViewController *)from toController:(UIViewController *)to URL:(NSString *)URL;

@end

#pragma mark - XYRouter
@interface XYRouter : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy, readonly) NSString *currentPath;
@property (nonatomic, strong) UIViewController *rootViewController;     // windows.rootViewController

@property (nonatomic, weak) id <XYRouterDelegate> delegate;

- (void)mapKey:(NSString *)key toControllerClassName:(NSString *)className;
- (void)mapKey:(NSString *)key toControllerInstance:(UIViewController *)viewController;
- (void)mapKey:(NSString *)key toBlock:(XYRouterBlock)block;
- (void)mapKey:(NSString *)key toNibName:(NSString *)nibName bundle:(NSBundle *)bundle;

// 当取出ViewController的时候, 如果有单例[ViewController sharedInstance], 默认返回单例, 如果没有, 返回[[ViewController alloc] init].
- (id)viewControllerForKey:(NSString *)key;
- (id)viewControllerForClassName:(NSString *)name;

- (void)openURLString:(NSString *)URLString;

@end


#pragma mark - UIViewController (XYRouter)
@interface UIViewController (XYRouter)
@property (nonatomic, copy, readonly) NSString *uxy_URLPath;
@end





