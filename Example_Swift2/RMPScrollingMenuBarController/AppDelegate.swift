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

import UIKit
import RMPScrollingMenuBarController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.setup()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - private methods

    func setup() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
        // Setup menu bar controller
        let menuController = RMPScrollingMenuBarController()
        menuController.delegate = self

        // Customize appearance of menu bar.
        menuController.view.backgroundColor = UIColor.whiteColor()
        menuController.menuBar.indicatorColor = UIColor.blueColor()
        //menuController.menuBar.style = .InfinitePaging
        //menuController.menuBar.showsIndicator = false
        //menuController.menuBar.showsSeparatorLine = false

        // Set ViewControllers for menu bar controller
        var viewControllers: [PageViewController] = []
        for var i = 0 ; i < 10 ; ++i {
            let vc = PageViewController()
            vc.view.backgroundColor = UIColor(white: CGFloat(0.3) + CGFloat(0.05) * CGFloat(i), alpha: 1)
            vc.message = "Message for No.\(i)"
            viewControllers.append(vc)
        }
        
        menuController.setViewControllers(viewControllers, animated: false)
        
        let naviController = UINavigationController(rootViewController: menuController)
        self.window?.rootViewController = naviController
        self.window?.makeKeyAndVisible()
    }
}

extension AppDelegate: RMPScrollingMenuBarControllerDelegate {
    func menuBarController(menuBarController: RMPScrollingMenuBarController!, willSelectViewController viewController: UIViewController!) {
        print("will select \(viewController)")
    }
    
    func menuBarController(menuBarController: RMPScrollingMenuBarController!, didSelectViewController viewController: UIViewController!) {
        print("did select \(viewController)")
    }
    
    func menuBarController(menuBarController: RMPScrollingMenuBarController!, didCancelViewController viewController: UIViewController!) {
        print("did cancel \(viewController)")
    }
    
    func menuBarController(menuBarController: RMPScrollingMenuBarController!, menuBarItemAtIndex index: Int) -> RMPScrollingMenuBarItem! {
        let item = RMPScrollingMenuBarItem()
        item.title = "Title \(index)"

        // Customize appearance of menu bar item.
        let button = item.button()
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Disabled)
        button.setTitleColor(UIColor.grayColor(), forState: .Selected)
        return item
    }
}
