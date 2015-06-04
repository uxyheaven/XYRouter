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

#pragma mark -
@interface BouncePresentAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@end
@implementation BouncePresentAnimation
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 1. Get controllers from transition context
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 2. Set init frame for toVC
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = CGRectOffset(finalFrame, screenBounds.size.width, 0);
    
    // 3. Add toVC's view to containerView
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toVC.view.frame = finalFrame;
                     } completion:^(BOOL finished) {
                         // 5. Tell context that we completed.
                         [transitionContext completeTransition:YES];
                     }];
}
@end

#pragma mark -
@interface NormalDismissAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@end
@implementation NormalDismissAnimation
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 1. Get controllers from transition context
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 2. Set init frame for fromVC
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame = CGRectOffset(initFrame, screenBounds.size.width, 0);
    
    // 3. Add target view to the container, and move it to back.
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView sendSubviewToBack:toVC.view];
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromVC.view.frame = finalFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end

#pragma mark -

@interface XYTransitioning : NSObject <UIViewControllerTransitioningDelegate>
+ (instancetype)sharedInstance;
@property (nonatomic, strong) BouncePresentAnimation *presentAnimation;
@property (nonatomic, strong) NormalDismissAnimation *dismissAnimation;
@end

@implementation XYTransitioning

+ (instancetype)sharedInstance
{
    static XYTransitioning *transitioning = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!transitioning) {
            transitioning = [[self alloc] init];
        }
    });
    return transitioning;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _presentAnimation = [[BouncePresentAnimation alloc] init];
        _dismissAnimation = [[NormalDismissAnimation alloc] init];
    }
    return self;
}
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimation;
}

@end
@implementation UIViewController (XYRouter)

- (void)uxy_pushViewController:(UIViewController *)viewController
                        params:(id)params
                      animated:(BOOL)flag
                    completion:(void (^)(void))completion
{
   // viewController.modalTransitionStyle = UIModalPresentationCurrentContext;
    viewController.transitioningDelegate = [XYTransitioning sharedInstance];
    
    [self presentViewController:viewController animated:flag completion:completion];
}

- (void)uxy_popViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion
{
    [self dismissViewControllerAnimated:flag completion:completion];
}

@end


