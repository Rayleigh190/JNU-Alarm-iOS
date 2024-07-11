//
//  DashboardViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/10/24.
//

import UIKit

class DashboardViewController: UIViewController {
    var dashboardView: DashboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupAddTarget()
    }
    
    override func loadView() {
        super.loadView()
        dashboardView = DashboardView(frame: self.view.frame)
        self.view = dashboardView
    }
}

extension DashboardViewController {
    func setupNavigationController() {
        navigationItem.title = "대시보드"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupAddTarget() {
        dashboardView.academicCalendarShortcutsButton.button.addTarget(self, action: #selector(pprint), for: .touchUpInside)
    }
    
    @objc func pprint(sender: UIButton) {
        print("\(sender)")
    }
}
