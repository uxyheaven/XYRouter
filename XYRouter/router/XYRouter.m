//
//  XYRouter.m
//  XYRouter
//
//  Created by heaven on 15/1/21.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "XYRouter.h"
#import <objc/runtime.h>

typedef enum
{
    XYRouteType_current,      // 当前目录         : 空 ./
    XYRouteType_back,         // 上一个目录       : ../
    XYRouteType_root,         // 根目录          : /
}XYRouteType;

@interface XYRouter ()

@property (nonatomic, strong) NSMutableDictionary *map;
@property (nonatomic, strong) UIViewController <XYRouteProtocol> *currentViewRoute;       // 当前的控制器
@property (nonatomic, strong) NSString *currentRoute;
@property (nonatomic, strong) NSString *finalRoute;

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
        Class objClass = NSClassFromString((NSString *)obj);
        if ( objClass && [objClass isSubclassOfClass:[UIViewController class]])
        {
            vc = [[objClass alloc] init];
        }
        
    }
    else if ([obj isKindOfClass:[UIViewController class]])
    {
        vc = (UIViewController *)obj;
    }
    else
    {
        XYRouterBlock objBlock = (XYRouterBlock)obj;
        vc = objBlock( key );
    }
    
    return vc;
}


- (void)openUrl:(NSString *)strUrl
{
    NSURL *url = [NSURL URLWithString:strUrl];
    NSLog(@"%@", url);
    
    NSArray *components = [url pathComponents];
    NSLog(@"%@", components);
    
    for (int i = 0; i < components.count; i++)
    {
        NSString *route = components[i];
        XYRouteType type = [self routeTypeByComponent:route];
        
        if (XYRouteType_back == type)
        {
            if ([_currentViewRoute respondsToSelector:@selector(gotoBack)])
            {
                [_currentViewRoute gotoBack];
            }
            [_currentViewRoute dismissViewControllerAnimated:NO completion:nil];
            [_currentViewRoute.navigationController popViewControllerAnimated:NO];
        }
        else if (XYRouteType_root == type)
        {
            //[UIWebView class];
            if ([_currentViewRoute respondsToSelector:@selector(gotoRoot)])
            {
                [_currentViewRoute gotoBack];
            }
        }
        else if (XYRouteType_current == type)
        {
            
        }
    }
}



#pragma mark - private
- (XYRouteType)routeTypeByComponent:(NSString *)component
{
    if ([@"./" isEqualToString:component])
    {
        return XYRouteType_current;
    }
    else if ([@"../" isEqualToString:component])
    {
        return XYRouteType_back;
    }
    else if ([@"/" isEqualToString:component])
    {
        return XYRouteType_root;
    }
    
    return XYRouteType_current;
}

- (void)executeRoute
{
    
}

@end

