//
//  AgreeViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 3/4/24.
//

import UIKit

class AgreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if !UserDefaults.standard.bool(forKey: "terms") {
            DispatchQueue.main.async {
                self.showAgreeAlert(title: "약관 동의", message: "(필수) 사용자 알림 구독 정보 저장을 위해 범용고유식별자(UUID)를 수집합니다.\n(비동의 시 서비스 이용 불가)")
            }
        } else {
            showContainer()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func showAgreeAlert(title: String, message: String) {
        //UIAlertController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Button
        let ok = UIAlertAction(title: "동의", style: .default, handler: {_ in
            print("동의")
            UserDefaults.standard.setValue(true, forKey: "terms")
            self.showContainer()
        })
        let cancel = UIAlertAction(title: "비동의", style: .default, handler: {_ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        })
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        if let vc = UIApplication.shared.keyWindow?.visibleViewController as? UIViewController {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    func showContainer() {
        DispatchQueue.main.async {
            let vc = ContainerViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }

}
