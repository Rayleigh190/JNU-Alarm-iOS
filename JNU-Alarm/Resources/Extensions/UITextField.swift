//
//  UITextField.swift
//  JNU-Alarm
//
//  Created by 우진 on 3/9/24.
//

import UIKit

extension UITextField {
    func addLeftRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}
