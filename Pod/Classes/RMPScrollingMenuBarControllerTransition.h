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

#import <Foundation/Foundation.h>
#import "RMPScrollingMenuBarController.h"
#import "RMPScrollingMenuBarControllerAnimator.h"

typedef void(^RMPScrollingMenuBarControllerTransitionContextCompletionBlock)(BOOL didComplete);
typedef void(^RMPScrollingMenuBarControllerInteractionControllerCancelCompletionBlock)();

/** Transition Delegate Object for view transitioning of Scrolling menu bar controller.
 */
@interface RMPScrollingMenuBarControllerTransition : NSObject <RMPScrollingMenuBarControllerTransitionDelegate>

- (instancetype)initWithMenuBarController:(RMPScrollingMenuBarController*)controller;

@end

/** InteractionController class for view transitioning of scrolling menu bar controller.
 */
@interface RMPScrollingMenuBarControllerInteractionController : NSObject <UIViewControllerInteractiveTransitioning>

@property(readonly) CGFloat percentComplete;


- (instancetype)initWithAnimator:(id<UIViewControllerAnimatedTransitioning>)animator;
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)context;
- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransitionWithCompletion:(RMPScrollingMenuBarControllerInteractionControllerCancelCompletionBlock)completion;
- (void)finishInteractiveTransition;

- (UIViewAnimationCurve)completionCurve;
- (CGFloat)completionSpeed;
@end

/** TransitionContext class for view transitioning of scrolling menu bar controller.
 */
@interface RMPScrollingMenuBarControllerTransitionContext : NSObject <UIViewControllerContextTransitioning>

@property (nonatomic, readonly)UIView* containerView;
@property (nonatomic, readonly, getter=isAnimated)BOOL animated;
@property (nonatomic, readonly, getter=isInteractive)BOOL interactive;
@property (nonatomic, readonly)UIModalPresentationStyle presentationStyle;
@property (nonatomic, readonly)RMPMenuBarControllerDirection direction;

- (instancetype)initWithMenuBarController:(RMPScrollingMenuBarController*)menuBarControlller
                       fromViewController:(UIViewController*)fromVC
                         toViewController:(UIViewController*)toVC
                                direction:(RMPMenuBarControllerDirection)direction
                                 animator:(RMPScrollingMenuBarControllerAnimator*)animator
                    interactionController:(id<UIViewControllerInteractiveTransitioning>)interactionController
                               completion:(RMPScrollingMenuBarControllerTransitionContextCompletionBlock)completion;

- (UIViewController *)viewControllerForKey:(NSString *)key;
- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)finishInteractiveTransition;
- (void)cancelInteractiveTransition;
- (BOOL)transitionWasCancelled;
- (void)completeTransition:(BOOL)didComplete;
- (CGRect)initialFrameForViewController:(UIViewController *)vc;
- (CGRect)finalFrameForViewController:(UIViewController *)vc;
@end
