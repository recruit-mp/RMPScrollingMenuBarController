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

#import "RMPScrollingMenuBarControllerTransition.h"

@interface RMPScrollingMenuBarControllerTransition ()


@end

@implementation RMPScrollingMenuBarControllerTransition {
    __weak RMPScrollingMenuBarController* _menuBarController;
    RMPScrollingMenuBarControllerAnimator* _animator;

    UIPanGestureRecognizer* _panGesture;

    RMPScrollingMenuBarControllerInteractionController* _interactionController;

    RMPMenuBarControllerDirection _direction;
}

- (instancetype)initWithMenuBarController:(RMPScrollingMenuBarController*)controller
{
    self = [super init];
    if(self){
        _menuBarController = controller;
        [self setup];
    }
    return self;
}

- (void)setup
{
    _animator = [[RMPScrollingMenuBarControllerAnimator alloc] init];
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDetectPanGesture:)];
    [_menuBarController.containerView addGestureRecognizer:_panGesture];
}

#pragma mark - gesture action
- (void)didDetectPanGesture:(UIPanGestureRecognizer*)gesture
{
    UIView* view = _menuBarController.containerView;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [gesture locationInView:view];
        if (location.x <  CGRectGetMidX(view.bounds)
            && _menuBarController.viewControllers.count > 1
            && _menuBarController.selectedIndex > 0) {
            // to left side menu item.
            _direction = RMPScrollingMenuBarControllerDirectionLeft;
            _interactionController = [[RMPScrollingMenuBarControllerInteractionController alloc] initWithAnimator:_animator];
            UIViewController* vc = _menuBarController.viewControllers[_menuBarController.selectedIndex-1];
            [_menuBarController setSelectedViewController:vc];
        }else if(location.x >=  CGRectGetMidX(view.bounds)
                 && _menuBarController.viewControllers.count > 1
                 && _menuBarController.selectedIndex < [_menuBarController.viewControllers count]-1){
            // to right side menu item.
            _direction = RMPScrollingMenuBarControllerDirectionRight;
            _interactionController = [[RMPScrollingMenuBarControllerInteractionController alloc] initWithAnimator:_animator];
            UIViewController* vc = _menuBarController.viewControllers[_menuBarController.selectedIndex+1];
            [_menuBarController setSelectedViewController:vc];
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:view];
        // Only if moving direction was matched, Updates the interaction controller.
        if((_direction == RMPScrollingMenuBarControllerDirectionLeft && translation.x > 0)
           || (_direction == RMPScrollingMenuBarControllerDirectionRight && translation.x < 0)){
            CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
            [_interactionController updateInteractiveTransition:d];
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        //If progress is less than 25%, Cancel transition.
        if (_interactionController.percentComplete > 0.25f) {
            [_interactionController finishInteractiveTransition];
        } else {
            [_interactionController cancelInteractiveTransition];
        }
        _interactionController = nil;
    }
}

#pragma mark - RMPScrollingMenuBarControllerTransitionDelegate
- (id <UIViewControllerAnimatedTransitioning>)menuBarController:(RMPScrollingMenuBarController*)menuBarController
                                animationControllerForDirection:(RMPMenuBarControllerDirection)direction
                                             fromViewController:(UIViewController *)fromViewController
                                               toViewController:(UIViewController *)toViewController
{
    return _animator;
}

- (id<UIViewControllerInteractiveTransitioning>)menuBarController:(RMPScrollingMenuBarController*)menuBarController
                      interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return _interactionController;
}

@end

#pragma mark -
@implementation RMPScrollingMenuBarControllerInteractionController {
    id<UIViewControllerAnimatedTransitioning> _animator;
    id<UIViewControllerContextTransitioning> _context;

    CADisplayLink* _displayLink;
}

- (instancetype)initWithAnimator:(id<UIViewControllerAnimatedTransitioning>)animator
{
    self = [super init];
    if(self){
        _animator = animator;
    }
    return self;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)context
{
    _context = context;
    _context.containerView.layer.speed = 0;
    [_animator animateTransition:_context];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    _percentComplete = percentComplete;
    NSTimeInterval duration = [_animator transitionDuration:_context];
    _context.containerView.layer.timeOffset = percentComplete*duration;
    [_context updateInteractiveTransition:percentComplete];
}

- (void)cancelInteractiveTransition
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateCancelAnimation)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)finishInteractiveTransition
{
    _context.containerView.layer.speed = self.completionSpeed;

    CFTimeInterval pausedTimeOffset = _context.containerView.layer.timeOffset;
    _context.containerView.layer.timeOffset = 0.0;
    _context.containerView.layer.beginTime = 0.0;
    CFTimeInterval newBeginTime = [_context.containerView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTimeOffset;
    _context.containerView.layer.beginTime = newBeginTime;

    [_context finishInteractiveTransition];
}

- (UIViewAnimationCurve)completionCurve
{
    return UIViewAnimationCurveLinear;
}

- (CGFloat)completionSpeed
{
    return 1.0f;
}

- (void)updateCancelAnimation
{
    // Rollback animation when cancelled.
    NSTimeInterval timeOffset = _context.containerView.layer.timeOffset - _displayLink.duration*0.3;
    if(timeOffset < 0){
        // Completed rollback.

        [_displayLink invalidate];
        _displayLink = nil;

        _context.containerView.layer.speed = self.completionSpeed;
        _context.containerView.layer.timeOffset = 0.0;

        UIViewController* toViewController = [_context viewControllerForKey:UITransitionContextToViewControllerKey];
        [toViewController.view.layer removeAllAnimations];
        UIViewController* fromViewController = [_context viewControllerForKey:UITransitionContextFromViewControllerKey];
        [fromViewController.view.layer removeAllAnimations];

        [_context cancelInteractiveTransition];
    }else {
        _context.containerView.layer.timeOffset = timeOffset;
    }
}

@end

#pragma mark -
@implementation RMPScrollingMenuBarControllerTransitionContext {
    RMPScrollingMenuBarController* _menuBarController;
    NSDictionary* _viewControllers;
    RMPScrollingMenuBarControllerAnimator* _animator;
    RMPScrollingMenuBarControllerTransitionContextCompletionBlock _completion;
    BOOL _isCancelled;

    CGRect _appearingToRect;
    CGRect _appearingFromRect;
    CGRect _disappearingToRect;
    CGRect _disappearingFromRect;
}

- (instancetype)initWithMenuBarController:(RMPScrollingMenuBarController*)menuBarControlller
                       fromViewController:(UIViewController*)fromVC
                         toViewController:(UIViewController*)toVC
                                direction:(RMPMenuBarControllerDirection)direction
                                 animator:(RMPScrollingMenuBarControllerAnimator*)animator
                    interactionController:(id<UIViewControllerInteractiveTransitioning>)interactionController
                               completion:(RMPScrollingMenuBarControllerTransitionContextCompletionBlock)completion;
{
    self = [super init];
    if(self){
        _menuBarController = menuBarControlller;
        _presentationStyle = UIModalPresentationNone;
        _interactive = (interactionController) ? YES : NO;
        _containerView = _menuBarController.containerView;
        _viewControllers = @{
                             UITransitionContextFromViewControllerKey:fromVC,
                             UITransitionContextToViewControllerKey:toVC,
                             };
        _direction = direction;
        _animator = animator;
        _completion = [completion copy];
        _isCancelled = NO;

        CGFloat offset = _containerView.bounds.size.width;
        offset *= (_direction == RMPScrollingMenuBarControllerDirectionRight) ? -1 : 1;
        _disappearingFromRect = _appearingToRect = _containerView.bounds;
        _disappearingToRect = CGRectOffset (_containerView.bounds, offset, 0);
        _appearingFromRect = CGRectOffset (_containerView.bounds, -offset, 0);
    }
    return self;
}

- (UIViewController *)viewControllerForKey:(NSString *)key
{
    return [_viewControllers objectForKey:key];
}

- (UIView*)viewForKey:(NSString *)key
{
    return [[_viewControllers objectForKey:key] view];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    _animated = YES;
}

- (void)finishInteractiveTransition
{
    _isCancelled = NO;
    _animated = NO;
}

- (void)cancelInteractiveTransition
{
    _isCancelled = YES;
    _animated = NO;
}

- (BOOL)transitionWasCancelled
{
    return _isCancelled;
}

- (void)completeTransition:(BOOL)didComplete
{
    if(_completion){
        _completion(didComplete);
    }

    if ([_animator respondsToSelector:@selector (animationEnded:)]) {
        [_animator animationEnded:didComplete];
    }
    _animated = NO;
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc
{
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return _disappearingFromRect;
    } else {
        return _appearingFromRect;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc
{
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return _disappearingToRect;
    } else {
        return _appearingToRect;
    }
}

- (CGAffineTransform)targetTransform
{
    return CGAffineTransformIdentity;
}
@end
