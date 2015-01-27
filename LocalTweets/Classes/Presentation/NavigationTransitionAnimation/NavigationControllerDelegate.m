//
//  NavigationControllerDelegate.m
//  LocalTweets
//
//  Created by Alexander Voronov on 27/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "NavigationPopAnimator.h"
#import "NavigationPushAnimator.h"

@interface NavigationControllerDelegate ()

@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) NavigationPushAnimator *pushAnimator;
@property (strong, nonatomic) NavigationPopAnimator *popAnimator;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition* interactionController;

@end


@implementation NavigationControllerDelegate

- (void)awakeFromNib {
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.navigationController.view addGestureRecognizer:panRecognizer];
    self.pushAnimator = [NavigationPushAnimator new];
    self.popAnimator = [NavigationPopAnimator new];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    UIView *view = self.navigationController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:view];
        if (location.x < CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) {
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactionController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:view].x > 0) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (UINavigationControllerOperationPop == operation) {
        return self.popAnimator;
    } else if (UINavigationControllerOperationPush == operation) {
        return self.pushAnimator;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionController;
}

@end
