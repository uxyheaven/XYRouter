//
//  XYRouter.m
//  XYRouter
//
//  Created by heaven on 15/1/21.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "XYRouter.h"
#import <objc/runtime.h>
#import "XYTransitioning.h"


@interface XYRouter ()

@property (nonatomic, strong) NSMutableDictionary *map;
@property (nonatomic, strong) UIViewController <XYRouteProtocol> *currentViewRoute;       // 当前的控制器
@property (nonatomic, strong) NSString *currentRoute;
@property (nonatomic, strong) NSString *finalRoute;
@property (nonatomic, strong) XYTransitioning *transitioning;

@end

@implementation XYRouter

+ (instancetype)sharedInstance
{
    static XYRouter *router = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!router) {
            router = [[self alloc] init];
        }
    });
    return router;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _map = [@{} mutableCopy];
        _currentRoute = @"";
        _transitioning = [[XYTransitioning alloc] init];
    }
    return self;
}

- (void)mapKey:(NSString *)key toControllerClassName:(NSString *)className
{
    if (key.length == 0)
    {
        return;
    }
    
    _map[key] = className;
}

- (void)mapKey:(NSString *)key toControllerInstance:(UIViewController *)viewController
{
    if (key.length == 0)
    {
        return;
    }
    
    _map[key] = viewController;
}


- (void)mapKey:(NSString *)key toBlock:(XYRouterBlock)block
{
    if (key.length == 0)
    {
        return;
    }
    
    _map[key] = block;
}

- (id)viewControllerForKey:(NSString *)key
{
    NSObject *obj = nil;
    
    if (key.length > 0)
    {
        obj = [_map objectForKey:key];
    }

    UIViewController *vc = nil;
    
    if (obj == nil)
    {
        return nil;
    }
    
    if ([obj isKindOfClass:[NSString class]])
    {
        Class classType = NSClassFromString((NSString *)obj);
#ifdef DEBUG
        NSString *error = [NSString stringWithFormat:@"%@ must be  a subclass of UIViewController class", obj];
        NSAssert([classType isSubclassOfClass:[UIViewController class]], error);
#endif
        if ([classType respondsToSelector:@selector(uxy_showedViewController)])
        {
            vc = [classType uxy_showedViewController];
        }
        else if ([classType respondsToSelector:@selector(sharedInstance)])
        {
            vc = [classType sharedInstance];
        }
        else
        {
            vc = [[classType alloc] init];
        }
    }
    else if ([obj isKindOfClass:[UIViewController class]])
    {
        vc = (UIViewController *)obj;
    }
    else
    {
        XYRouterBlock objBlock = (XYRouterBlock)obj;
        vc = objBlock();
    }
    
    return vc;
}


- (void)openUrl:(NSString *)strUrl
{
    NSURL *url = [NSURL URLWithString:strUrl];
    NSLog(@"%@", url);
    
    NSArray *components = [url pathComponents];
    NSLog(@"%@", components);
    
    // 设置当前的url
    XYRouteType type = [self routeTypeByComponent:strUrl];
    
    for (int i = 0; i < components.count; i++)
    {
        NSString *route = components[i];
        XYRouteType tmpType = [self routeTypeByComponent:route];
        
        if (XYRouteUrlType_pushAfterPop == tmpType)
        {
            if ([_currentViewRoute respondsToSelector:@selector(gotoBack)])
            {
                [_currentViewRoute gotoBack];
            }
            [_currentViewRoute dismissViewControllerAnimated:NO completion:nil];
            [_currentViewRoute.navigationController popViewControllerAnimated:NO];
        }
        else if (XYRouteUrlType_pushAfterGotoRoot == tmpType)
        {
            //[UIWebView class];
            if ([_currentViewRoute respondsToSelector:@selector(gotoRoot)])
            {
                [_currentViewRoute gotoBack];
            }
        }
        else if (XYRouteUrlType_push == tmpType)
        {
            
        }
    }
}

- (void)openUrl:(NSString *)strUrl atNavigationController:(UINavigationController *)navigationController
{
    NSURL *url = [NSURL URLWithString:strUrl];
    NSLog(@"%@", url);
    
    NSArray *components = [url pathComponents];
    NSLog(@"%@", components);
    
    // 先看需求pop一些vc
    XYRouteType type = [self routeTypeByComponent:components[0]];
    if (type == XYRouteUrlType_push)
    {
    }
    else if (type == XYRouteUrlType_pushAfterPop)
    {
        [navigationController popViewControllerAnimated:NO];
    }
    else if (type == XYRouteUrlType_pushAfterGotoRoot)
    {
        [navigationController popToRootViewControllerAnimated:NO];
    }
    
    // 只有一个直接push
    if (components.count == 1)
    {
        UIViewController *vc = [self viewControllerForKey:[components lastObject]];
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = ((UINavigationController *)vc).topViewController;
        }
        [navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    // 无动画push中间的vc
    for (int i = 0; i < components.count - 1; i++) {
        UIViewController *vc = [self viewControllerForKey:components[i]];
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = ((UINavigationController *)vc).topViewController;
        }
        [navigationController pushViewController:vc animated:NO];
    }
    
    // push最后的vc
    UIViewController *vc = [self viewControllerForKey:[components lastObject]];
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        vc = ((UINavigationController *)vc).topViewController;
    }
    [navigationController pushViewController:vc animated:YES];

    
}
#pragma mark - private
- (XYRouteType)routeTypeByComponent:(NSString *)component
{
    if ([@"." isEqualToString:component])
    {
        return XYRouteUrlType_push;
    }
    else if ([@".." isEqualToString:component])
    {
        return XYRouteUrlType_pushAfterPop;
    }
    else if ([@"/" isEqualToString:component])
    {
        return XYRouteUrlType_pushAfterGotoRoot;
    }
    
    return XYRouteUrlType_push;
}

- (void)executeRoute
{
    
}

@end

#pragma mark -
@implementation UIViewController (XYRouter)

- (void)uxy_pushViewController:(UIViewController *)viewController
                        params:(id)params
                      animated:(BOOL)flag
                    completion:(void (^)(id viewController))completion
{
    if ([XYRouter sharedInstance].transitioning)
    {
        viewController.transitioningDelegate = [XYRouter sharedInstance].transitioning;
        [[XYRouter sharedInstance].transitioning.transitionController wireToViewController:viewController];
    }
    else
    {
       // viewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    }


    [self presentViewController:viewController animated:flag completion:^{
        !completion ?: completion(viewController);
    }];

   // [self showDetailViewController:viewController sender:self];
}

- (void)uxy_popViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion
{
    [self dismissViewControllerAnimated:flag completion:completion];
}

- (void)uxy_openUrl:(NSString *)url
{
    UIViewController *vc = [[XYRouter sharedInstance] viewControllerForKey:url];
    [self uxy_pushViewController:vc params:nil animated:YES completion:nil];
}

- (void)uxy_goBack
{
    [self uxy_popViewControllerAnimated:YES completion:nil];
}

- (void)uxy_pushViewController:(UIViewController *)viewController
                        params:(id)params
                      animated:(BOOL)flag
{
    if (viewController.navigationController &&
        (viewController.navigationController != self))
    {
        [viewController.navigationController popViewControllerAnimated:NO];
    }
}
@end


