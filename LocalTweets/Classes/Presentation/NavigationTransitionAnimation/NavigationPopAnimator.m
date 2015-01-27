//
//  NavigationPopAnimator.m
//  LocalTweets
//
//  Created by Alexander Voronov on 27/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "NavigationPopAnimator.h"

@interface NavigationPopAnimator()

@property (nonatomic, assign) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation NavigationPopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.75;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)animationTransitionContext {
    self.transitionContext = animationTransitionContext;
    
    UIViewController *toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[self.transitionContext containerView] addSubview:toViewController.view];
    
    CGFloat initialRadius = 2;
    CGFloat initialOriginX = CGRectGetWidth(fromViewController.view.frame)/2-initialRadius;
    CGFloat initialOriginY = CGRectGetHeight(fromViewController.view.frame)/2-initialRadius;
    UIBezierPath *circleMaskPathInitial = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(initialOriginX, initialOriginY, initialRadius*2, initialRadius*2)];
    CGFloat finalHeight = CGRectGetHeight(fromViewController.view.frame) + 88;
    CGFloat finalOriginX = 0 - (finalHeight - CGRectGetWidth(fromViewController.view.frame))/2;
    CGFloat finalOriginY = -44;
    UIBezierPath *circleMaskPathFinal = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(finalOriginX, finalOriginY, finalHeight, finalHeight)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = circleMaskPathFinal.CGPath;
    toViewController.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(circleMaskPathInitial.CGPath);
    maskLayerAnimation.toValue = (__bridge id)(circleMaskPathFinal.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:self.transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}

@end
