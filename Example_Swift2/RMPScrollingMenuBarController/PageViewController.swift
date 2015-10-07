//
//  PageViewController.swift
//  RMPScrollingMenuBarController
//
//  Created by Yuichi Hirano on 10/7/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    private var messageLabel: UILabel?

    private var _message: String?
    var message: String? {
        get {
            return _message
        }
        set(newMessage) {
            _message = newMessage
            messageLabel?.text = _message
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var f = self.view.bounds;
        f.size.height = 32;
        messageLabel = UILabel(frame: f)
        messageLabel?.numberOfLines = 0
        messageLabel?.textColor = UIColor.whiteColor()
        messageLabel?.textAlignment = .Center
        messageLabel?.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);
        self.view.addSubview(messageLabel!)
        
        if message != nil {
            messageLabel?.text = message;
        }

    }

}
