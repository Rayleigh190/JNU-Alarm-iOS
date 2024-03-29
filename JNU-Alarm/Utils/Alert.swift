//
//  Alert.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/27/24.
//

import Foundation
import UIKit

class Alert {
    class func showAlert(title: String, message: String) {
        //UIAlertController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Button
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        if let vc = UIApplication.shared.keyWindow?.visibleViewController as? UIViewController {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIWindow {
    
    public var visibleViewController: UIViewController? {
        return self.visibleViewControllerFrom(vc: self.rootViewController)
    }
    
    /**
     # visibleViewControllerFrom
     - Author: suni
     - Date:
     - Parameters:
        - vc: rootViewController 혹은 UITapViewController
     - Returns: UIViewController?
     - Note: vc내에서 가장 최상위에 있는 뷰컨트롤러 반환
    */
    public func visibleViewControllerFrom(vc: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return self.visibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return self.visibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return self.visibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
}

