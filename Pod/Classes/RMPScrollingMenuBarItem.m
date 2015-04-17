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

#import "RMPScrollingMenuBarItem.h"

@implementation RMPScrollingMenuBarButton {

}

+ (instancetype)button
{
    RMPScrollingMenuBarButton* button = [self buttonWithType:UIButtonTypeCustom];

    return button;
}

@end

@implementation RMPScrollingMenuBarItem {
    RMPScrollingMenuBarButton* _itemButton;
    CGFloat _width;
}

+ (instancetype)item
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if(self){
        _width = kRMPScrollingMenuBarItemDefaultWidth;
        _enabled = YES;
    }
    return self;
}

- (RMPScrollingMenuBarButton*)button
{
    if(!_itemButton){
        RMPScrollingMenuBarButton* button = [RMPScrollingMenuBarButton button];
        _itemButton = button;
        _itemButton.tag = self.tag;
        _itemButton.frame = CGRectMake(0, 0, _width, 24);

        _itemButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_itemButton setTitle:self.title
                     forState:UIControlStateNormal];
        [_itemButton setTitleColor:[UIColor colorWithRed:0.647 green:0.631 blue:0.604 alpha:1.000]
                          forState:UIControlStateNormal];
        [_itemButton setTitleColor:[UIColor colorWithWhite:0.886 alpha:1.000]
                          forState:UIControlStateDisabled];
        [_itemButton setTitleColor:[UIColor colorWithRed:0.988 green:0.224 blue:0.129 alpha:1.000]
                          forState:UIControlStateSelected];
        _itemButton.enabled = _enabled;
        _itemButton.exclusiveTouch = NO;
        [_itemButton sizeToFit];
    }
    return _itemButton;
}

- (CGFloat)width
{
    return _itemButton.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
    _itemButton.frame = CGRectMake(0, 0, _width, 36);
    [_itemButton sizeToFit];
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    _itemButton.enabled = _enabled;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    _itemButton.selected = selected;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<RMPScrollingMenuItem: %@ %@>", self.title, NSStringFromCGRect(self.button.frame)];
}

@end
