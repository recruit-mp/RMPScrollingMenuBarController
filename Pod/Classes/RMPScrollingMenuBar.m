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

#import "RMPScrollingMenuBar.h"

@implementation RMPScrollingMenuBar {
    UIScrollView* _scrollView;
    UIView* _indicatorView;
    UIView* _border;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat w, h;
    if(self.superview){
        w = self.superview.bounds.size.width;
    }else {
        w = [[UIScreen mainScreen] bounds].size.width;
    }
    h = _barHeight;

    return CGSizeMake(w, h);
}

- (void)layoutSubviews
{
    _scrollView.frame = self.bounds;
    _scrollView.contentInset = UIEdgeInsetsZero;

    CGFloat lineWidth = 1.0f/[[UIScreen mainScreen] scale];
    _border.frame = CGRectMake(0, self.bounds.size.height - lineWidth, self.bounds.size.width, lineWidth);
}

#pragma mark -
- (void)setup
{
    _barHeight = kRMPMenuBarDefaultBarHeight;
    _itemInsets = UIEdgeInsetsZero;
    _indicatorColor = [UIColor colorWithRed:0.988 green:0.224 blue:0.129 alpha:1.000];

    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView = scrollView;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointZero;
    _scrollView.scrollsToTop = NO;
    [self addSubview:_scrollView];

    UIView* indicator = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 4, 0, 2)];
    _indicatorView = indicator;
    _indicatorView.backgroundColor = _indicatorColor;
    [_scrollView addSubview:_indicatorView];

    UIView* border = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 0.25f, self.bounds.size.width, 0.25f)];
    _border = border;
    _border.backgroundColor = [UIColor colorWithWhite:0.698 alpha:1.000];
    [self addSubview:_border];
}

- (void)setItems:(NSArray *)items
{
    [self setItems:items animated:NO];
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated
{
    CGRect f;
    _items = [items copy];

    // Clear all of menu items.
    for(UIView* view in _scrollView.subviews){
        if([view isKindOfClass:[RMPScrollingMenuBarButton class]]){
            [view removeFromSuperview];
        }
    }

    // Set up button of menu items.
    CGFloat offset = _itemInsets.left;
    for(RMPScrollingMenuBarItem* item in _items){
        RMPScrollingMenuBarButton* view = [item button];
        if(view){
            f = CGRectMake(offset, _itemInsets.top, item.width,
                           _scrollView.bounds.size.height-_itemInsets.top + _itemInsets.bottom);
            offset += f.size.width + _itemInsets.right + _itemInsets.left;
            view.frame = f;
            view.alpha = 0.0;
            [_scrollView addSubview:view];

            [(RMPScrollingMenuBarButton*)view addTarget:self
                                         action:@selector(didTapMenuButton:)
                               forControlEvents:UIControlEventTouchUpInside];

        }
    }
    CGFloat contentWidth = offset - _itemInsets.left;
    if(contentWidth < _scrollView.bounds.size.width){
        // Align items to center if number of items is less.
        offset = (_scrollView.bounds.size.width - contentWidth)*0.5;
        contentWidth = _scrollView.bounds.size.width;
        for(UIView* view in _scrollView.subviews){
            if([view isKindOfClass:[RMPScrollingMenuBarButton class]]){
                f = view.frame;
                f.origin.x += offset;
                view.frame = f;
            }
        }

    }
    _scrollView.contentSize = CGSizeMake(contentWidth, _scrollView.bounds.size.height);


    if(!animated){
        // Without Animate.
        for(UIView* view in _scrollView.subviews){
            if([view isKindOfClass:[RMPScrollingMenuBarButton class]]){
                view.alpha = 1.0;
            }
        }
    }else {
        // With Animate.
        int i = 0;
        for(UIView* view in _scrollView.subviews){
            if([view isKindOfClass:[RMPScrollingMenuBarButton class]]){
                [self animateButton:view atIndex:i];
                i++;
            }
        }
    }

    if(!_selectedItem){
        [self setSelectedItem:_items[0]];
    }
}

- (void)updateMenuButtonLayout
{

}

- (void)animateButton:(UIView*)view atIndex:(NSInteger)index
{
    view.transform = CGAffineTransformMakeScale(1.4, 1.4);
    [UIView animateWithDuration:0.24 delay:0.06 + 0.10*index
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.alpha = 1.0;
                         view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     } completion:^(BOOL finished) {
                         ;
                     }];
}

- (void)setSelectedItem:(RMPScrollingMenuBarItem *)selectedItem
{
    if(_selectedItem){
        _selectedItem.selected = NO;
    }
    _selectedItem = selectedItem;
    _selectedItem.selected = YES;

    // Selected item want to be displayed to center as possible.
    CGPoint offset = CGPointZero;
    if(_selectedItem.button.center.x > _scrollView.bounds.size.width*0.5
       && _scrollView.contentSize.width - _selectedItem.button.center.x > _scrollView.bounds.size.width*0.5){
        offset = CGPointMake(_selectedItem.button.center.x - _scrollView.frame.size.width*0.5, 0);
    }else if(_selectedItem.button.center.x < _scrollView.bounds.size.width*0.5){
        offset = CGPointMake(0, 0);
    }else if(_scrollView.contentSize.width - _selectedItem.button.center.x < _scrollView.bounds.size.width*0.5){
        offset = CGPointMake(_scrollView.contentSize.width-_scrollView.bounds.size.width, 0);
    }
    [_scrollView setContentOffset:offset animated:YES];


    CGPoint newPosition = [_scrollView convertPoint:CGPointZero fromView:_selectedItem.button];
    if(_indicatorView.frame.origin.x == 0.0 && _indicatorView.frame.size.width == 0.0){
        CGRect f = _indicatorView.frame;
        f.origin.x = newPosition.x - 3;
        f.size.width = _selectedItem.button.frame.size.width + 6;
        _indicatorView.frame = f;
    }else {
        NSTimeInterval dur = fabs(newPosition.x - _indicatorView.frame.origin.x)/160.0*0.4*0.8;
        if(dur < 0.38){
            dur = 0.38;
        }else if(dur > 0.6){
            dur = 0.6;
        }
        [UIView animateWithDuration:dur
                              delay:0.16
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect f = _indicatorView.frame;
                             f.origin.x = newPosition.x - 3;
                             f.size.width = _selectedItem.button.frame.size.width + 6;
                             _indicatorView.frame = f;
                         } completion:^(BOOL finished) {
                             ;
                         }];
    }



    if([_delegate respondsToSelector:@selector(menuBar:didSelectItem:)]){
        [_delegate menuBar:self didSelectItem:_selectedItem];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    if(_indicatorView){
        _indicatorView.backgroundColor = _indicatorColor;
    }
}

#pragma mark - button action
- (void)didTapMenuButton:(id)sender
{
    for(RMPScrollingMenuBarItem* item in _items){
        if(sender == item.button){
            self.selectedItem = item;
            break;
        }
    }
}
@end
