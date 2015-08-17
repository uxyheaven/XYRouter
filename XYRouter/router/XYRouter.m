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

#pragma mark - XYRouter_private
@interface NSString (XYRouter_private)
- (NSMutableDictionary *)__uxy_dictionaryFromQueryComponents;
@end
#pragma mark - UIViewController_private
@interface UIViewController (UIViewController_private)
@property (nonatomic, copy) NSString *uxy_pathComponent;
@end

#pragma mark -
@interface XYRouter ()

@property (nonatomic, strong) NSMutableDictionary *map;
@property (nonatomic, strong) UIViewController <XYRouteProtocol> *currentViewRoute;       // 当前的控制器
@property (nonatomic, copy) NSString *currentPath;
@property (nonatomic, strong) XYTransitioning *transitioning;

@property (nonatomic, assign) BOOL isPathCacheChanged;

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
        _map                = [@{} mutableCopy];
        _isPathCacheChanged = YES;
        //_transitioning = [[XYTransitioning alloc] init];
    }
    return self;
}
- (NSString *)currentPath
{
    if (_isPathCacheChanged)
    {
        __block NSString *string = @"";
        UINavigationController *nvc = [[self class] __visibleNavigationController];
        [nvc.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
            string = [NSString stringWithFormat:@"%@/%@", string, vc.uxy_pathComponent];
        }];
        _currentPath = string;
    }
    
    return _currentPath;
}
- (void)setRootViewController:(UIViewController *)rootViewController
{
    if (_rootViewController != rootViewController)
    {
        [UIApplication sharedApplication].delegate.window.rootViewController = rootViewController;
        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
        _rootViewController = rootViewController;
    }
}

- (void)registerNavigationController:(UINavigationController *)navigationController
{
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

    if (obj == nil) return nil;

    UIViewController *vc = nil;
    
    if ([obj isKindOfClass:[NSString class]])
    {
        Class classType = NSClassFromString((NSString *)obj);
#ifdef DEBUG
        NSString *error = [NSString stringWithFormat:@"%@ must be  a subclass of UIViewController class", obj];
        NSAssert([classType isSubclassOfClass:[UIViewController class]], error);
#endif
        if ([classType respondsToSelector:@selector(sharedInstance)])
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
    
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        ((UINavigationController *)vc).visibleViewController.uxy_pathComponent = key;
    }
    else
    {
        vc.uxy_pathComponent = key;
    }
    
    return vc;
}

- (void)openPath:(NSString *)path
{
    NSURL *url                   = [NSURL URLWithString:path];
    NSArray *components          = [url pathComponents];
    NSDictionary *queryDictonary = [self __dictionaryFromQuery:url.query];
    NSString *scheme             = url.scheme;
    NSString *host               = url.host;
    NSString *parameterString    = url.parameterString;
    _isPathCacheChanged          = YES;
    
    BOOL isHostChanged = [self __handleHost:host];
    
    if (isHostChanged)
    {
        // todo 处理host改变的情况
    }
    
    if (components.count == 0)
    {
        return;
    }
    
    UINavigationController *nvc = [[self class] __visibleNavigationController];
    
    // 先看需求pop一些vc
    [self __handlePopViewControllerByComponents:components atNavigationController:nvc];
    
    // 多个路径先无动画push中间的vc
    for (NSInteger i = 0; i < components.count - 1; i++)
    {
        if ([components[i] isEqualToString:@"."] || [components[i] isEqualToString:@".."]) continue;
        
        UIViewController *vc = [self viewControllerForKey:components[i]];
        [self __pushViewController:vc parameters:nil atNavigationController:nvc animated:NO];
    }
    
    // 最后在push最后的vc
    UIViewController *vc = [self viewControllerForKey:[components lastObject]];
    [self __pushViewController:vc parameters:queryDictonary atNavigationController:nvc animated:YES];
}

+ (UINavigationController *)visibleNavigationController
{
    return (UINavigationController *)@"miss";
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

+ (UINavigationController *)__visibleNavigationController
{
    UINavigationController *nvc = [[self class] visibleNavigationController];
    if ([nvc isKindOfClass:[UINavigationController class]])
    {
        return nvc;
    }
    else
    {
        UIViewController *vc = [self __visibleViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
        UINavigationController *nvc = (UINavigationController *)([vc isKindOfClass:[UINavigationController class]] ? vc : vc.navigationController);
        return nvc;
    }
}

+ (UIViewController*)__visibleViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tbc = (UITabBarController*)rootViewController;
        return [self __visibleViewControllerWithRootViewController:tbc.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nvc = (UINavigationController*)rootViewController;
        return [self __visibleViewControllerWithRootViewController:nvc.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController *presentedVC = rootViewController.presentedViewController;
        return [self __visibleViewControllerWithRootViewController:presentedVC];
    }
    else
    {
        return rootViewController;
    }
}
// 处理host改变的情况
- (BOOL)__handleHost:(NSString *)host
{
    if (host.length > 0)
    {
        UIViewController *vc = [self viewControllerForKey:host];
        self.rootViewController = vc;
        return YES;
    }
    
    return NO;
}

// 先看需求pop一些vc
- (void)__handlePopViewControllerByComponents:(NSArray *)components atNavigationController:(UINavigationController *)navigationController
{
    XYRouteType type = [self routeTypeByComponent:[components firstObject]];
    BOOL animated = NO;
    if (components.count == 1 &&
        ([components[0] isEqualToString:@".."] || [components[0] isEqualToString:@"/"]))
    {
        animated = YES;
    }
    
    if (type == XYRouteUrlType_push)
    {
    }
    else if (type == XYRouteUrlType_pushAfterPop)
    {
        [navigationController popViewControllerAnimated:animated];
    }
    else if (type == XYRouteUrlType_pushAfterGotoRoot)
    {
        [navigationController popToRootViewControllerAnimated:animated];
    }
}

- (NSInteger)lastSameComponentWithComponents:(NSArray *)components viewControllers:(NSArray *)vcs
{
    NSInteger max = MIN(components.count, vcs.count);
    
    NSInteger result = 0;
    for (NSInteger i = 1; i < max; i++)
    {
        // NSLog(@"%@ %@", components[i], [vcs[i] uxy_pathComponent]);
        if (![components[i] isEqualToString:[vcs[i] uxy_pathComponent]])
        {
            result = i - 1;
            break;
        }
    }
    
    return result;
}

- (void)__pushViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters atNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated
{
    if (viewController == nil || [viewController isKindOfClass:[UINavigationController class]] || navigationController == nil) return;
    
    [navigationController pushViewController:viewController animated:animated];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // todo 安全性检查
        [viewController setValue:obj forKey:key];
    }];
}

- (NSString *)__URLDecodingWithEncodingString:(NSString *)encodingString
{
    NSMutableString *string = [NSMutableString stringWithString:encodingString];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)__dictionaryFromQuery:(NSString *)query
{
    NSMutableDictionary *result = [@{} mutableCopy];
    NSArray *array = [query componentsSeparatedByString:@"&"];
    for (NSString *keyValuePairString in array)
    {
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if ([keyValuePairArray count] < 2) continue;
        
        NSString *key   = [self __URLDecodingWithEncodingString:keyValuePairArray[0]];
        NSString *value = [self __URLDecodingWithEncodingString:keyValuePairArray[1]];
        result[key]     = value;
    }
    
    return result;
}
@end

#pragma mark -
static const char *XYRouter_pathComponent = "UIViewController.pathComponent";

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

- (NSString *)uxy_pathComponent
{
    return objc_getAssociatedObject(self, XYRouter_pathComponent);
}

- (void)setUxy_pathComponent:(NSString *)uxy_pathComponent
{
    objc_setAssociatedObject(self, XYRouter_pathComponent, uxy_pathComponent, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

#pragma mark - XYRouter_private


#pragma mark -







