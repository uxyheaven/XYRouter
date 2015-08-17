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
 * path改变时候检查已有的path, 无需重新生成
 * host改变的时候nav的问题
 */

typedef enum
{
    XYRouteUrlType_invalid,                     // 无效
    XYRouteUrlType_push,                        // 在当前目录push               : ./
    XYRouteUrlType_pushAfterPop,                // 在上一个目录push             : ../
    XYRouteUrlType_pushAfterGotoRoot,           // 在根目录根push               : /
    // XYRouteUrlType_push,                     // 在当前目录push               : 空
}XYRouteType;

typedef UIViewController *(^XYRouterBlock)();

@interface XYRouter : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy, readonly) NSString *currentPath;
@property (nonatomic, strong) UIViewController *rootViewController;     // windows.rootViewController

- (void)mapKey:(NSString *)key toControllerClassName:(NSString *)className;
- (void)mapKey:(NSString *)key toControllerInstance:(UIViewController *)viewController;
- (void)mapKey:(NSString *)key toBlock:(XYRouterBlock)block;

- (id)viewControllerForKey:(NSString *)key;

- (void)openPath:(NSString *)path;

/// 默认有个返回实际显示navigationController的方法. 你也可以在子类重写这个方法返回你期望的 navigationController
+ (UINavigationController *)visibleNavigationController;

@end
#pragma mark -

@interface UIViewController (XYRouter)
@property (nonatomic, copy, readonly) NSString *uxy_pathComponent;
@end

