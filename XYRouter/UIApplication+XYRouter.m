//
//  UIApplication+XYRouter.m
//  XYRouterDemo
//
//  Created by Heaven on 16/4/29.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "UIApplication+XYRouter.h"
#import "XYRouter.h"
#import <objc/runtime.h>
#import <objc/message.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"

@implementation UIApplication (XYRouter)

+ (void)load
{
    NSArray *array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    if (array.count == 0)
    {
        return;
    }

    [array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSArray *schemes = obj[@"CFBundleURLSchemes"];

        if (![schemes isKindOfClass:[NSArray class]] || schemes.count == 0)
        {
            return;
        }

        NSString *URLSchemes = schemes[0];
        if (![URLSchemes isEqualToString:@"XYRouter"])
        {
            return;
        }

        [self __uxy_hook_handleOpenURL];
    }];
}

+ (void)__uxy_hook_handleOpenURL
{
    //  Class clazz = [[[UIApplication sharedApplication] delegate] class];

    static dispatch_once_t once;
    static NSMutableArray *classNames;

    dispatch_once(&once, ^
    {
        unsigned int classesCount = 0;

        classNames = [[NSMutableArray alloc] init];
        Class *classes = objc_copyClassList(&classesCount);

        for (unsigned int i = 0; i < classesCount; ++i)
        {
            Class classType = classes[i];
            if (class_isMetaClass(classType) )
            {
                continue;
            }

            Class superClass = class_getSuperclass(classType);
            if (Nil == superClass)
            {
                continue;
            }

            NSString *className = NSStringFromClass(classType);
            if (0 == className.length)
            {
                continue;
            }

            [classNames addObject:className];
        }

        free(classes);
    });


    NSMutableArray *results = [[NSMutableArray alloc] init];
    Protocol *protocol      = NSProtocolFromString(@"UIApplicationDelegate");
    for (NSString *className in classNames)
    {
        Class classType = NSClassFromString(className);
        if (classType == self)
        {
            continue;
        }

        if (NO == [classType conformsToProtocol:protocol])
        {
            continue;
        }

        [results addObject:className];
    }

    Class clazz = NSClassFromString(results[0]);

    Method a1 = class_getInstanceMethod(clazz, @selector(application:openURL:options:));
    class_addMethod(clazz, @selector(uxyIMPApplicationOpenURLOptions), (IMP)uxyIMPApplicationOpenURLOptions, "B@:@@@");
    Method b1 = class_getInstanceMethod(clazz, @selector(uxyIMPApplicationOpenURLOptions));

    if (class_addMethod(clazz, @selector(application:openURL:options:), (IMP)uxyIMPApplicationOpenURLOptions, "B@:@@@"))
    {
        class_replaceMethod(clazz, @selector(uxyIMPApplicationOpenURLOptions), method_getImplementation(a1), method_getTypeEncoding(a1));
    }
    else
    {
        method_exchangeImplementations(a1, b1);
    }

    Method a2 = class_getInstanceMethod(clazz, @selector(application:handleOpenURL:));
    class_addMethod(clazz, @selector(uxyIMPApplicationHandleOpenURL), (IMP)uxyIMPApplicationHandleOpenURL, "B@:@@");
    Method b2 = class_getInstanceMethod(clazz, @selector(uxyIMPApplicationHandleOpenURL));

    if (class_addMethod(clazz, @selector(application:handleOpenURL:), (IMP)uxyIMPApplicationHandleOpenURL, "B@:@@"))
    {
        class_replaceMethod(clazz, @selector(uxyIMPApplicationHandleOpenURL), method_getImplementation(a2), method_getTypeEncoding(a2));
    }
    else
    {
        method_exchangeImplementations(a2, b2);
    }
}

BOOL uxyIMPApplicationOpenURLOptions(id self, SEL _cmd, UIApplication *application, NSURL *url, NSDictionary *options)
{
    NSString *str = [url absoluteString];

    if ([str hasPrefix:@"XYRouter://"])
    {
        str = [str substringFromIndex:11];
        [[XYRouter sharedInstance] openURLString:str];
    }

    NSMethodSignature *sig   = [[[[UIApplication sharedApplication] delegate] class] instanceMethodSignatureForSelector:@selector(uxyIMPApplicationOpenURLOptions)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    invocation.target   = self;
    invocation.selector = @selector(uxyIMPApplicationOpenURLOptions);
    [invocation setArgument:&application atIndex:2];
    [invocation setArgument:&url atIndex:3];
    [invocation setArgument:&options atIndex:4];
    [invocation invoke];
    BOOL returnValue;
    [invocation getReturnValue:&returnValue];

    return returnValue;
}

BOOL uxyIMPApplicationHandleOpenURL(id self, SEL _cmd, UIApplication *application, NSURL *url)
{
    NSString *str = [url absoluteString];

    if ([str hasPrefix:@"XYRouter://"])
    {
        str = [str substringFromIndex:11];
        [[XYRouter sharedInstance] openURLString:str];
    }

    NSMethodSignature *sig   = [[[[UIApplication sharedApplication] delegate] class] instanceMethodSignatureForSelector:@selector(uxyIMPApplicationHandleOpenURL:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    invocation.target   = self;
    invocation.selector = @selector(uxyIMPApplicationHandleOpenURL:);
    [invocation setArgument:&application atIndex:2];
    [invocation setArgument:&url atIndex:3];
    [invocation invoke];
    BOOL returnValue;
    [invocation getReturnValue:&returnValue];

    return returnValue;
}

@end

#pragma clang diagnostic pop
