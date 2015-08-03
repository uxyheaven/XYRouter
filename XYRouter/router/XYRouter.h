//
//  XYRouter.h
//  XYRouter
//
//  Created by heaven on 15/1/21.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/* todo
 * 1 懒加载
 * 2 内存释放
 * 3 openUrl
 */

typedef enum
{
    XYRouteUrlType_invalid,                     // 无效
    XYRouteUrlType_push,                        // 在当前目录push               : ./
    XYRouteUrlType_pushAfterPop,                // 在上一个目录push             : ../
    XYRouteUrlType_pushAfterGotoRoot,           // 在根目录根push               : /
    // XYRouteUrlType_push,                     // 在当前目录push               : 空
}XYRouteType;

@protocol XYRouteProtocol <NSObject>

@end

@protocol XYRouteViewControllerProtocol <NSObject>

+ (UIViewController *)uxy_showedViewController;

@end


typedef UIViewController *(^XYRouterBlock)();

@interface XYRouter : NSObject

+ (instancetype)sharedInstance;
//+ (instancetype)routerWithHost:(NSString *)host;      // 通过这个生成不同的绑定?

//+ (void)setRootViewController:(UIViewController *)viewController;

@property (nonatomic, copy, readonly) NSString *currentPath;
@property (nonatomic, strong) UIViewController *rootViewController;     // windows.rootViewController

- (void)mapKey:(NSString *)key toControllerClassName:(NSString *)className;
- (void)mapKey:(NSString *)key toControllerInstance:(UIViewController *)viewController;
- (void)mapKey:(NSString *)key toBlock:(XYRouterBlock)block;

- (id)viewControllerForKey:(NSString *)key;

// 传参问题?
- (void)openPath:(NSString *)path atNavigationController:(UINavigationController *)navigationController;

+ (UINavigationController *)topNavigationController;

@end

#pragma mark -
@interface UIViewController (XYRouter)

- (void)uxy_pushViewController:(UIViewController *)viewController
                        params:(id)params
                      animated:(BOOL)flag
                    completion:(void (^)(id viewController))completion;

- (void)uxy_popViewControllerAnimated:(BOOL)flag
                           completion:(void (^)(void))completion;

- (void)uxy_openUrl:(NSString *)url;
- (void)uxy_goBack;

@end