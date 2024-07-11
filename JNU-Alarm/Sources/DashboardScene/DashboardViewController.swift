//
//  DashboardViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/10/24.
//

import UIKit
import SafariServices

class DashboardViewController: UIViewController {
    var dashboardView: DashboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupAddTarget()
        addShortcutButton() // 테스트용 추가
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
    
    func addShortcutButton() {
        var shortcutButtons = [
            ShortcutButton(name: "학생회", imageNmae: "person.3.fill", imageColor: UIColor(hexCode: "0632A0"), link: "https://jnuheyday.imweb.me/", isModal: false),
            ShortcutButton(name: "전대신문", imageNmae: "newspaper.fill", imageColor: UIColor(hexCode: "208C3B"), link: "https://press.cnumedia.jnu.ac.kr/", isModal: false),
        ]
        
        while shortcutButtons.count%4 != 0 {
            shortcutButtons.append(ShortcutButton(name: "", imageNmae: "", imageColor: .black, link: ""))
        }
        shortcutButtons.forEach {
            $0.addTarget(self, action: #selector(openInSafariAction), for: .touchUpInside)
        }
        for i in stride(from: 0, to: shortcutButtons.count, by: 4) {
            dashboardView.shortcutButtonStackView.addArrangedSubview(
                ShortcutRowStackView([shortcutButtons[i], shortcutButtons[i+1], shortcutButtons[i+2], shortcutButtons[i+3]])
            )
        }
        
    }
}
