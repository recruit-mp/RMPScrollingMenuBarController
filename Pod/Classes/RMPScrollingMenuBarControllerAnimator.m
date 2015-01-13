//  Copyright (c) 2015 Recruit Marketing Partners Co.,Ltd. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RMPScrollingMenuBarControllerAnimator.h"
#import "RMPScrollingMenuBarControllerTransition.h"

@implementation RMPScrollingMenuBarControllerAnimator {
    RMPScrollingMenuBarControllerTransitionContext* _transitionContext;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    RMPScrollingMenuBarControllerTransitionContext* tc = (RMPScrollingMenuBarControllerTransitionContext*)transitionContext;

    UIViewController* toViewController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];

    [[transitionContext containerView] addSubview:toViewController.view];
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];

    _transitionContext = tc;

    CGRect fromInitialFrame = [tc initialFrameForViewController:fromViewController];
    CGRect fromFinalFrame = [tc finalFrameForViewController:fromViewController];
    CGRect toInitialFrame = [tc initialFrameForViewController:toViewController];
    CGRect toFinalFrame = [tc finalFrameForViewController:toViewController];
    fromViewController.view.frame = fromInitialFrame;
    toViewController.view.frame = toInitialFrame;
    //fromViewController.view.alpha = 1.0;
    //toViewController.view.alpha = 1.0;

    [CATransaction begin];
    CGPoint point;

    // Animation of fromView
    CABasicAnimation* fromViewAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    point = fromInitialFrame.origin;
    point.x += fromInitialFrame.size.width*0.5;
    point.y += fromInitialFrame.size.height*0.5;
    [fromViewAnimation setFromValue:[NSValue valueWithCGPoint:point]];
    point = fromFinalFrame.origin;
    point.x += fromFinalFrame.size.width*0.5;
    point.y += fromFinalFrame.size.height*0.5;
    [fromViewAnimation setToValue:[NSValue valueWithCGPoint:point]];
    [fromViewAnimation setDuration:[self transitionDuration:transitionContext]];
    [fromViewAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    // Maintain final animation state.
    [fromViewAnimation setRemovedOnCompletion:NO];
    [fromViewAnimation setFillMode:kCAFillModeForwards];
    [fromViewController.view.layer addAnimation:fromViewAnimation forKey:@"from_transition"];

    // Animation of toView
    CABasicAnimation* toViewAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    point = toInitialFrame.origin;
    point.x += toInitialFrame.size.width*0.5;
    point.y += toInitialFrame.size.height*0.5;
    [toViewAnimation setFromValue:[NSValue valueWithCGPoint:point]];
    point = toFinalFrame.origin;
    point.x += toFinalFrame.size.width*0.5;
    point.y += toFinalFrame.size.height*0.5;
    [toViewAnimation setToValue:[NSValue valueWithCGPoint:point]];
    [toViewAnimation setDuration:[self transitionDuration:transitionContext]];
    [toViewAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    // Maintain final animation state.
    [toViewAnimation setRemovedOnCompletion:NO];
    [toViewAnimation setFillMode:kCAFillModeForwards];
    [toViewAnimation setDelegate:self];
    [toViewController.view.layer addAnimation:toViewAnimation forKey:@"to_transition"];

    [CATransaction commit];
}

- (void)animationDidStart:(CAAnimation *)anim
{

}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    UIViewController* toViewController = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if([_transitionContext transitionWasCancelled]){
        fromViewController.view.frame = [_transitionContext initialFrameForViewController:fromViewController];
        toViewController.view.frame = [_transitionContext initialFrameForViewController:toViewController];
    }else {
        fromViewController.view.frame = [_transitionContext finalFrameForViewController:fromViewController];
        toViewController.view.frame = [_transitionContext finalFrameForViewController:toViewController];
    }
    [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];

    // Remove animations
    [fromViewController.view.layer removeAllAnimations];
    [toViewController.view.layer removeAllAnimations];
}


@end
