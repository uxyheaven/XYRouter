//
//  XYTransitioning.h
//  XYRouter
//
//  Created by XingYao on 15/7/28.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BouncePresentAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@end
@interface NormalDismissAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@end
@interface SwipeUpInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interacting;
- (void)wireToViewController:(UIViewController*)viewController;
@end

#pragma mark -
@interface XYTransitioning : NSObject <UIViewControllerTransitioningDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic, strong) BouncePresentAnimation *presentAnimation;
@property (nonatomic, strong) NormalDismissAnimation *dismissAnimation;
@property (nonatomic, strong) SwipeUpInteractiveTransition *transitionController;

@end


