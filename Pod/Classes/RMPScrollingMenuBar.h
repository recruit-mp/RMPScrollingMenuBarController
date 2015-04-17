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
#import "RMPScrollingMenuBarItem.h"

#define kRMPMenuBarDefaultBarHeight 36.0f

typedef NS_ENUM(NSUInteger, RMPScrollingMenuBarStyle) {
    RMPScrollingMenuBarStyleNormal,
    RMPScrollingMenuBarStyleInfinitePaging,
};

typedef NS_ENUM(NSInteger, RMPScrollingMenuBarDirection){
    RMPScrollingMenuBarDirectionNone,
    RMPScrollingMenuBarDirectionLeft,
    RMPScrollingMenuBarDirectionRight,
};

@class RMPScrollingMenuBar;

/** ScrollingMenuBar's delegate protocol
 */
@protocol RMPScrollingMenuBarDelegate <NSObject>

- (void)menuBar:(RMPScrollingMenuBar*)menuBar didSelectItem:(RMPScrollingMenuBarItem*)item direction:(RMPScrollingMenuBarDirection)direction;

@end

/** View Class of ScrollingMenuBar
 */
@interface RMPScrollingMenuBar : UIView

/** Height of menu bar
 */
@property (nonatomic, assign)CGFloat barHeight;

/** Insets of menu items on menu bar. Use for adjusting spaces between menu items.
 */
@property (nonatomic, assign)UIEdgeInsets itemInsets;

/** Delegate object
 */
@property (nonatomic, weak)id<RMPScrollingMenuBarDelegate> delegate;

/** Array of menu items.
 */
@property (nonatomic, copy)NSArray* items;

/** Selected menu item.
 */
@property (nonatomic, weak)RMPScrollingMenuBarItem* selectedItem;

/** A Boolean value that controls whether the indicator is visible or not. 
    Default value is YES.
 */
@property (nonatomic, assign)BOOL showsIndicator;

/** Color of indicator which be displayed under selected menu item.
 */
@property (nonatomic, strong)UIColor* indicatorColor;

/** A Boolean value that controls whether the separator line is visible or not.
 Default value is YES.
 */
@property (nonatomic, assign)BOOL showsSeparatorLine;

/* The menu bar style that specifies its behaviour.
 */
@property (nonatomic, assign)RMPScrollingMenuBarStyle style;

@property (nonatomic, readonly)CGFloat scrollOffsetX;

/** Setter of menu items.
 */
- (void)setItems:(NSArray *)items animated:(BOOL)animated;

/** Scrolls menu bar by a ratio of the width of the item
    Move to right item by setting to 1.0, Also Move to left item by setting to -1.0.
 */
- (void)scrollByRatio:(CGFloat)ratio from:(CGFloat)from;


@end
