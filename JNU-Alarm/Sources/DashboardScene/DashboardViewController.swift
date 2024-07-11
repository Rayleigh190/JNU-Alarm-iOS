//
//  DashboardViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/10/24.
//

import UIKit
import SafariServices
import Combine

class DashboardViewController: UIViewController {
    var dashboardView: DashboardView!
    let dashboardViewModel = DashboardViewModel()
    var disposalbleBag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupAddTarget()
        setBindings()
        self.dashboardViewModel.getShortcutButtonData()
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
        [
            dashboardView.academicCalendarShortcutButton,
            dashboardView.schoolMenuShortcutButton
        ].forEach {
            $0.addTarget(self, action: #selector(openInSafariAction), for: .touchUpInside)
        }

        let action1 = UIAction(title: "용봉", image: UIImage(systemName: "mappin.and.ellipse")) { _ in
            self.openInSafari(link: "https://dormitory.jnu.ac.kr/Board/Board.aspx?BoardID=2")
        }
        let action2 = UIAction(title: "여수", image: UIImage(systemName: "mappin.and.ellipse")) { _ in
            self.openInSafari(link: "https://house.jnu.ac.kr/Board/Board.aspx?BoardID=36")
        }
        let action3 = UIAction(title: "화순", image: UIImage(systemName: "mappin.and.ellipse")) { _ in
            self.openInSafari(link: "https://hsdorm.jnu.ac.kr/Board/Board.aspx?BoardID=70")
        }
        let menu = UIMenu(title: "생활관", children: [action1, action2, action3])
        dashboardView.dormitoryMenuShortcutButton.menu = menu
        dashboardView.dormitoryMenuShortcutButton.showsMenuAsPrimaryAction = true
    }
    
    @objc func openInSafariAction(sender: ShortcutButton) {
        guard let shortcutLink = sender.shortcutLink else { return }
        guard let url = URL(string: shortcutLink) else { return }
        let safariVC = SFSafariViewController(url: url)
        if sender.isModal {
            safariVC.modalPresentationStyle = .automatic
        }
        present(safariVC, animated: true)
    }
    
    @objc func openInSafari(link: String) {
        guard let url = URL(string: link) else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .automatic
        present(safariVC, animated: true)
    }
}

extension DashboardViewController {
    fileprivate func setBindings() {
        print("DashboardViewController - setBindings()")
        self.dashboardViewModel.$shortcutButtonList.sink { (shortcutButtonList: [ShortcutButton]) in
            self.setShortcutButton(shortcutButtonList: shortcutButtonList)
        }.store(in: &disposalbleBag)
    }
    
    func setShortcutButton(shortcutButtonList: [ShortcutButton]) {
        var shortcutButtons: [ShortcutButton] = shortcutButtonList
        while shortcutButtons.count%4 != 0 {
            shortcutButtons.append(ShortcutButton(name: "", imageNmae: "", imageColor: .black, link: ""))
        }
        shortcutButtons.forEach {
            $0.addTarget(self, action: #selector(self.openInSafariAction), for: .touchUpInside)
        }
        for i in stride(from: 0, to: shortcutButtons.count, by: 4) {
            self.dashboardView.shortcutButtonStackView.addArrangedSubview(
                ShortcutRowStackView([shortcutButtons[i], shortcutButtons[i+1], shortcutButtons[i+2], shortcutButtons[i+3]])
            )
        }
    }
}
