//
//  NavigationPushAnimator.m
//  LocalTweets
//
//  Created by Alexander Voronov on 27/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "NavigationPushAnimator.h"

@implementation NavigationPushAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    toViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        toViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

@end
