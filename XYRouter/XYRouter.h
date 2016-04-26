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
#define __XYROUTER_VERSION__    "0.6.5" // 主版本号

typedef enum
{
    XYRouteURLType_invalid,                     // 无效
    XYRouteURLType_push,                        // 在当前目录push               : ./
    XYRouteURLType_pushAfterPop,                // 在上一个目录push             : ../
    XYRouteURLType_pushAfterGotoRoot,           // 在根目录根push               : /
    // XYRouteURLType_push,                     // 在当前目录push               : 空
}XYRouteType;

typedef UIViewController *  (^XYRouterBlock)();

@interface XYRouter : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy, readonly) NSString *currentPath;
@property (nonatomic, strong) UIViewController *rootViewController;     // windows.rootViewController

- (void)mapKey:(NSString *)key toControllerClassName:(NSString *)className;
- (void)mapKey:(NSString *)key toControllerInstance:(UIViewController *)viewController;
- (void)mapKey:(NSString *)key toBlock:(XYRouterBlock)block;
- (void)mapKey:(NSString *)key toNibName:(NSString *)nibName bundle:(NSBundle *)bundle;

// 当取出ViewController的时候, 如果有单例[ViewController sharedInstance], 默认返回单例, 如果没有, 返回[[ViewController alloc] init].
- (id)viewControllerForKey:(NSString *)key;

- (void)openURLString:(NSString *)URLString;

#pragma mark - override
/// 默认有个返回实际显示navigationController的方法. 你也可以在重写这个方法,以返回你期望的 navigationController
+ (UINavigationController *)expectedVisibleNavigationController;
@end


#pragma mark - UIViewController (XYRouter)
@interface UIViewController (XYRouter)
@property (nonatomic, copy, readonly) NSString *uxy_URLPath;
@end





