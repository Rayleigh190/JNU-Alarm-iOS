import Foundation
import UIKit

class Alert {
    class func showAlert(title: String, message: String) {
        // UIAlertController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Button
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        if let vc = UIApplication.shared.windows.first?.visibleViewController {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showAlertAndExit(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        alert.addAction(okAction)
        
        if let vc = UIApplication.shared.windows.first?.visibleViewController {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showForceUpdateAlert() {
        let alert = UIAlertController(title: "필수 업데이트 알림", message: "더 나은 서비스를 위해 새 버전이 나왔습니다!\n업데이트를 해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id6478808485") else { return }
            if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(okAction)
        
        if let vc = UIApplication.shared.windows.first?.visibleViewController {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showRecommendUpdateAlert() {
        let alert = UIAlertController(title: "권장 업데이트 알림", message: "안정적인 서비스 이용을 위해 업데이트를 권장합니다!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id6478808485") else { return }
            if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let noAction = UIAlertAction(title: "다음에", style: .destructive) { _ in
            // Todo: 하루동안 권장 업데이트 알림 안 보이게 하기
        }
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        if let vc = UIApplication.shared.windows.first?.visibleViewController {
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
    public func visibleViewControllerFrom(vc: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
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
