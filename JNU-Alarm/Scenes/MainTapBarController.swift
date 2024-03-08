//
//  MainTapBarController.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/14/24.
//

import UIKit

class MainTapBarController: UITabBarController {
    
    private lazy var historyViewController: UIViewController = {
       let viewController = UINavigationController(rootViewController: HistoryViewController())
       let tabBarItem = UITabBarItem(title: "알림", image: UIImage(systemName: "list.bullet"), tag: 0)
       viewController.tabBarItem = tabBarItem

       return viewController
   }()

   private lazy var settingViewController: UIViewController = {
       let viewController = UINavigationController(rootViewController: SettingViewController())
       let tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gear"), tag: 1)
       viewController.tabBarItem = tabBarItem

       return viewController
   }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [historyViewController, settingViewController]
        setFirst()
        // 푸시 알림 클릭시 알림 내역 탭 뛰우기
        NotificationCenter.default.addObserver(self, selector: #selector(showHistoryTap(_:)), name: NSNotification.Name("showHistoryTap"), object: nil)
    }
    
    func setFirst() {
        if UserDefaults.standard.array(forKey: "notifications") as? [String] == nil {
            UserDefaults.standard.set([], forKey: "notifications")
        }
    }
    
    @objc func showHistoryTap(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            if let index = userInfo["index"] as? Int {
                self.selectedIndex = index
            }
        }
    }
}
