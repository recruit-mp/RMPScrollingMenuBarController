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

        var f = self.view.bounds
        f.size.height = 32
        messageLabel = UILabel(frame: f)
        messageLabel?.numberOfLines = 0
        messageLabel?.textColor = UIColor.whiteColor()
        messageLabel?.textAlignment = .Center
        messageLabel?.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5)
        self.view.addSubview(messageLabel!)
        
        if message != nil {
            messageLabel?.text = message
        }

    }

}
