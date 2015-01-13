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

#import <UIKit/UIKit.h>
#import "RMPScrollingMenuBar.h"

@class RMPScrollingMenuBarController;

typedef NS_ENUM(NSInteger, RMPMenuBarControllerDirection){
    RMPScrollingMenuBarControllerDirectionLeft,
    RMPScrollingMenuBarControllerDirectionRight,
};

/** ScrollingMenuBarController's Delegate
 */
@protocol RMPScrollingMenuBarControllerDelegate <NSObject>

@optional
/** The delegate method which be called before select menu item.
 */
- (void)menuBarController:(RMPScrollingMenuBarController*)menuBarController willSelectViewController:(UIViewController*)viewController;

/** The delegate method which be called after select menu item.
 */
- (void)menuBarController:(RMPScrollingMenuBarController*)menuBarController didSelectViewController:(UIViewController*)viewController;

/** The delegate method which be called after selection was canceled.
 */
- (void)menuBarController:(RMPScrollingMenuBarController*)menuBarController didCancelViewController:(UIViewController*)viewController;

/** The delegate method which be called when set up menu bar items dynamically.
 */
- (RMPScrollingMenuBarItem*)menuBarController:(RMPScrollingMenuBarController*)menuBarController menuBarItemAtIndex:(NSInteger)index;

@end

// MenuBarController's delegate for view transitioning
@protocol RMPScrollingMenuBarControllerTransitionDelegate <NSObject>

@optional
- (id <UIViewControllerAnimatedTransitioning>)menuBarController:(RMPScrollingMenuBarController*)menuBarController
                                animationControllerForDirection:(RMPMenuBarControllerDirection)direction
                                             fromViewController:(UIViewController *)fromViewController
                                               toViewController:(UIViewController *)toViewController;

- (id<UIViewControllerInteractiveTransitioning>)menuBarController:(RMPScrollingMenuBarController*)menuBarController
                      interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController;
@end

/** Container type ViewController class of with a scrollable menu bar
 */
@interface RMPScrollingMenuBarController : UIViewController

/** ScrollingMenuBar object.
 */
@property (nonatomic, readonly)RMPScrollingMenuBar* menuBar;

/** Container view for presenting view of child view controller.
 */
@property (nonatomic, readonly)UIView*      containerView;

/** NSArray of child view controllers.
 */
@property (nonatomic, retain)NSArray* viewControllers;

/** Selected view controller.
 */
@property (nonatomic, weak)UIViewController* selectedViewController;

/** Index of selected view controller.
 */
@property (nonatomic, assign)NSInteger       selectedIndex;

/** Delegate object.
 */
@property (nonatomic, weak)id<RMPScrollingMenuBarControllerDelegate> delegate;

/** Transition Delegate object
 */
@property (nonatomic, weak)id<RMPScrollingMenuBarControllerTransitionDelegate> transitionDelegate;

/** Setter of view controllers.
 */
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;


@end

#import "UIViewController+RMPScrollingMenuBarControllerHelper.h"
