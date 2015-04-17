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

#import "RMPScrollingMenuBarController.h"
#import "RMPScrollingMenuBarControllerTransition.h"

@interface RMPScrollingMenuBarController () <RMPScrollingMenuBarDelegate>

@end

@implementation RMPScrollingMenuBarController {
    NSArray* _items;

    RMPScrollingMenuBarControllerTransition* _transition;
    
    RMPScrollingMenuBarDirection _menuBarDirection;
}


- (void)loadView
{
    [super loadView];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];

    CGRect rect;
    // Menu bar
    rect = CGRectMake(0, 0, self.view.bounds.size.width, kRMPMenuBarDefaultBarHeight);
    RMPScrollingMenuBar* menuBar = [[RMPScrollingMenuBar alloc] initWithFrame:rect];
    _menuBar = menuBar;
    CGFloat offset = 32.0f / 320.0f * [[UIScreen mainScreen] bounds].size.width;
    _menuBar.itemInsets = UIEdgeInsetsMake(2, offset, 0, offset);
    [self.view addSubview:menuBar];
    [_menuBar sizeToFit];
    rect = _menuBar.frame;
    rect.origin.y = [self.topLayoutGuide length];
    _menuBar.frame = rect;
    _menuBar.delegate = self;
    _menuBar.backgroundColor = self.view.backgroundColor;

    // Container
    CGFloat y = CGRectGetMaxY(_menuBar.frame);
    rect = CGRectMake(0, y,
                      self.view.bounds.size.width,
                      self.view.bounds.size.height - y);
    UIView* containerView = [[UIView alloc] initWithFrame:rect];
    _containerView = containerView;
    _containerView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self.view addSubview:_containerView];

    [self.view insertSubview:self.containerView belowSubview:self.menuBar];

    _transition = [[RMPScrollingMenuBarControllerTransition alloc] initWithMenuBarController:self];
    self.transitionDelegate = _transition;

    if([_viewControllers count] > 0){
        [self updateMenuBarWithViewControllers:_viewControllers animated:NO];
        [self setSelectedViewController:_viewControllers[0]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGRect rect;
    rect = CGRectMake(0, [self.topLayoutGuide length], self.view.bounds.size.width, _menuBar.barHeight);
    _menuBar.frame = rect;

    rect = CGRectMake(0, CGRectGetMaxY(_menuBar.frame),
                      self.view.bounds.size.width,
                      self.view.bounds.size.height - CGRectGetMaxY(_menuBar.frame));
    _containerView.frame = rect;


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -
- (void)setViewControllers:(NSArray *)viewControllers
{
    [self setViewControllers:viewControllers animated:NO];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    _viewControllers = [viewControllers copy];

    if(_menuBar){
        [self updateMenuBarWithViewControllers:_viewControllers animated:animated];
    }

    if([_viewControllers count] > 0){
        [self setSelectedViewController:_viewControllers[0]];
    }
}

- (void)updateMenuBarWithViewControllers:(NSArray*)viewControllers animated:(BOOL)animated
{
    // Update menu bar items.
    NSMutableArray* items = [NSMutableArray array];
    RMPScrollingMenuBarItem* item = nil;
    int i = 0;
    for(UIViewController* vc in viewControllers){
        if([_delegate respondsToSelector:@selector(menuBarController:menuBarItemAtIndex:)]){
            item = [_delegate menuBarController:self menuBarItemAtIndex:i];
        }else {
            item = [RMPScrollingMenuBarItem item];
            item.title = vc.title;
            item.tag = i;
        }
        [items addObject:item];
        i++;
    }
    _items = [NSArray arrayWithArray:items];

    [_menuBar setItems:_items animated:animated];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    if([_viewControllers containsObject:selectedViewController]){
        [self transitionToViewController:selectedViewController];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(selectedIndex >= 0
       && selectedIndex < [_viewControllers count]
       && selectedIndex != _selectedIndex){
        [self setSelectedViewController:_viewControllers[selectedIndex]];
    }
}

#pragma mark - Private
- (void)transitionToViewController:(UIViewController*)toViewController
{
    UIViewController *fromViewController = _selectedViewController;
    // Do nothing if toViewController equals to fromViewController.
    if (toViewController == fromViewController || !_containerView) {
        return;
    }

    // Disabled the interaction of menu bar.
    _menuBar.userInteractionEnabled = NO;

    UIView *toView = toViewController.view;
    toView.frame = _containerView.bounds;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];

    if([_delegate respondsToSelector:@selector(menuBarController:willSelectViewController:)]){
        [_delegate menuBarController:self willSelectViewController:toViewController];
    }

    // Present toViewController if not exist fromViewController.
    if (!fromViewController) {
        [_containerView addSubview:toViewController.view];
        [toViewController didMoveToParentViewController:self];

        // Reflect selection state.
        [self finishTransitionWithViewController:toViewController cancelViewController:nil];

        return;
    }

    // Switch views with animation
    NSInteger fromIndex = [_viewControllers indexOfObject:fromViewController];
    NSInteger toIndex = [_viewControllers indexOfObject:toViewController];
    RMPMenuBarControllerDirection direction = RMPScrollingMenuBarControllerDirectionLeft;
    if(toIndex > fromIndex){
        direction = RMPScrollingMenuBarControllerDirectionRight;
    }
    
    if(self.menuBar.style == RMPScrollingMenuBarStyleInfinitePaging){
        if(toIndex == 0 && fromIndex == _viewControllers.count-1){
            direction = RMPScrollingMenuBarControllerDirectionRight;
        }else if(toIndex == _viewControllers.count-1 && fromIndex == 0){
            direction = RMPScrollingMenuBarControllerDirectionLeft;
        }
        
        if(_menuBarDirection == RMPScrollingMenuBarDirectionRight){
            direction = RMPScrollingMenuBarControllerDirectionRight;
        }else if(_menuBarDirection == RMPScrollingMenuBarDirectionLeft){
            direction = RMPScrollingMenuBarControllerDirectionLeft;
        }
        _menuBarDirection = RMPScrollingMenuBarDirectionNone;
    }

    id<UIViewControllerAnimatedTransitioning> animator = nil;
    if ([_transitionDelegate respondsToSelector:@selector(menuBarController:animationControllerForDirection:fromViewController:toViewController:)]) {
        animator = [_transitionDelegate menuBarController:self
                          animationControllerForDirection:direction
                                       fromViewController:fromViewController
                                         toViewController:toViewController];
    }
    animator = (animator ?: [[RMPScrollingMenuBarControllerAnimator alloc] init]);

    UIPercentDrivenInteractiveTransition* interactionController = nil;
    if([_transitionDelegate respondsToSelector:@selector(menuBarController:interactionControllerForAnimationController:)]) {
        interactionController = [_transitionDelegate menuBarController:self
                           interactionControllerForAnimationController:animator];
    }

    RMPScrollingMenuBarControllerTransitionContextCompletionBlock completion = ^(BOOL didComplete){
        if(didComplete){
            [fromViewController.view removeFromSuperview];
            [fromViewController removeFromParentViewController];
            [toViewController didMoveToParentViewController:self];

            // Reflect selection state.
            [self finishTransitionWithViewController:toViewController cancelViewController:nil];
        }else {
            // Remove toViewController from parent view controller by cancelled.
            [toViewController.view removeFromSuperview];
            [toViewController removeFromParentViewController];
            [toViewController didMoveToParentViewController:nil];

            // Reflect selection state.
            [self finishTransitionWithViewController:fromViewController cancelViewController:toViewController];
        }


    };

    RMPScrollingMenuBarControllerTransitionContext* transitionContext = nil;
    transitionContext = [[RMPScrollingMenuBarControllerTransitionContext alloc] initWithMenuBarController:self
                                                                               fromViewController:fromViewController
                                                                                 toViewController:toViewController
                                                                                        direction:direction
                                                                                         animator:animator
                                                                            interactionController:interactionController
                                                                                       completion:completion];



    if(transitionContext.isInteractive){
        [interactionController startInteractiveTransition:transitionContext];
    }else {
        [animator animateTransition:transitionContext];
    }
}

- (void)finishTransitionWithViewController:(UIViewController*)viewController cancelViewController:(UIViewController*)cancelViewController
{
    NSInteger lastIndex = _selectedIndex;
    UIViewController* lastViewController = _selectedViewController;

    // Reflect selection state.
    _selectedViewController = viewController;
    _selectedIndex = [_viewControllers indexOfObject:viewController];

    // Update menu bar.
    RMPScrollingMenuBarItem* item = _menuBar.items[_selectedIndex];
    if(item != _menuBar.selectedItem){
        [_menuBar setSelectedItem:item];
    }

    // Call delegate method.
    if(lastIndex != _selectedIndex || lastViewController != _selectedViewController){
        if([_delegate respondsToSelector:@selector(menuBarController:didSelectViewController:)]){
            [_delegate menuBarController:self didSelectViewController:_selectedViewController];
        }
    }else {
        if([_delegate respondsToSelector:@selector(menuBarController:didCancelViewController:)]){
            [_delegate menuBarController:self didCancelViewController:cancelViewController];
        }
    }
    
    _menuBar.userInteractionEnabled = YES;
}

#pragma mark - RMPScrollingMenuBarDelegate
- (void)menuBar:(RMPScrollingMenuBar*)menuBar didSelectItem:(RMPScrollingMenuBarItem*)item direction:(RMPScrollingMenuBarDirection)direction
{
    NSInteger index = [_items indexOfObject:item];
    if(index != NSNotFound
       && index != self.selectedIndex){
        // Switch view controller.
        _menuBarDirection = direction;
        [self setSelectedIndex:index];
    }
}
@end
