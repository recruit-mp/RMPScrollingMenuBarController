# RMPScrollingMenuBarController

[![Version](https://img.shields.io/cocoapods/v/RMPScrollingMenuBarController.svg?style=flat)](http://cocoadocs.org/docsets/RMPScrollingMenuBarController)
[![License](https://img.shields.io/cocoapods/l/RMPScrollingMenuBarController.svg?style=flat)](http://cocoadocs.org/docsets/RMPScrollingMenuBarController)
[![Platform](https://img.shields.io/cocoapods/p/RMPScrollingMenuBarController.svg?style=flat)](http://cocoadocs.org/docsets/RMPScrollingMenuBarController)

## Overview

`RMPScrollingMenuBarController` has a scrollable menu bar, and multiple view controllers.

You can switch view controllers, which is managed like a `UITabBarController`, by swiping a screen or scrolling the menu.


![Screen shot](docs/rmpscrollingmenubarcontroller.gif)

## Installation

RMPScrollingMenuBarController is available through [CocoaPods](http://cocoapods.org).   
To install
it, simply add the following line to your Podfile:

```ruby
pod "RMPScrollingMenuBarController"
```

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Setup is as below:  
```objective-c
RMPScrollingMenuBarController* menuController = [[RMPScrollingMenuBarController alloc] init];
menuController.delegate = self;

NSArray* viewControllers = @[vc1, vc2, vc3, vc4, vc5];
[menuController setViewControllers:viewControllers];

UINavigationController* naviController;
naviController = [[UINavigationController alloc] initWithRootViewController:menuController];
```

Delegate methods are as below:
```objective-c
- (RMPScrollingMenuBarItem*)menuBarController:(RMPScrollingMenuBarController *)menuBarController
                           menuBarItemAtIndex:(NSInteger)index
{
    RMPScrollingMenuBarItem* item = [[RMPScrollingMenuBarItem alloc] init];
    item.title = [NSString stringWithFormat:@"Title %02ld", (long)(index+1)];
    
    return item;
}

- (void)menuBarController:(RMPScrollingMenuBarController *)menuBarController
 willSelectViewController:(UIViewController *)viewController
{
    NSLog(@"will select %@", viewController);
}

- (void)menuBarController:(RMPScrollingMenuBarController *)menuBarController
  didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"did select %@", viewController);
}

- (void)menuBarController:(RMPScrollingMenuBarController *)menuBarController
  didCancelViewController:(UIViewController *)viewController
{
    NSLog(@"did cancel %@", viewController);
}

```

## Customize

You can customize menu bar, as below:  
```objective-c
RMPScrollingMenuBarController* menuController = [[RMPScrollingMenuBarController alloc] init];

// Sets background color.
menuController.view.backgroundColor = [UIColor whiteColor];

// Sets color of indicator line which displayed under menu bar item.
menuController.menuBar.indicatorColor = [UIColor blueColor];

// Hides indicator line which displayed under menu bar item.
menuController.menuBar.showsIndicator = NO;

// Hides Separator line which displayed bottom of menu bar.
menuController.menuBar.showsSeparatorLine = NO;

```

Also you can customize buttons of menu bar item by implementing delegate methods, as below:  
```objective-c

- (RMPScrollingMenuBarItem*)menuBarController:(RMPScrollingMenuBarController *)menuBarController
                           menuBarItemAtIndex:(NSInteger)index
{
    RMPScrollingMenuBarItem* item = [[RMPScrollingMenuBarItem alloc] init];
    item.title = titles[index];

    // Customize appearance of menu bar item.
    UIButton* button = item.button;
    [button setTitleColor:[UIColor lightGrayColor]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor]
                 forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor greenColor]
                 forState:UIControlStateSelected];
    
    return item;
}

```

## Infinite paging
Enables infinite paging mode, as below:  
```objective-c
RMPScrollingMenuBarController* menuController = [[RMPScrollingMenuBarController alloc] init];
menuController.menuBar.style = RMPScrollingMenuBarStyleInfinitePaging;

```


## Requirements

- iOS 7.0 or higher 

## Change Log

### 1.0.6 
- Adds infinite paging mode.
  
### 1.0.5
- Adds properties for customizing appearance.

### 1.0.4
- Fixes crash issue.

### 1.0.1 ~ 1.0.3
- Fixes minor issues.

### 1.0.0
- First release.

## Contribution

If you have feature requests or bug reports, feel free to help out by sending pull requests or by creating new issues.

## Author

Yoshihiro Kato, yoshihiro@sputnik-apps.com  
Recruit Marketing Partners Co.,Ltd. recruit_mp_oss@ml.cocorou.jp

## License

RMPScrollingMenuBarController is available under the MIT license.
