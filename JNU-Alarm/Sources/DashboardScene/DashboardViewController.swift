//
//  DashboardViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/10/24.
//

import UIKit
import SafariServices
import Combine
import Kingfisher
import Toast

class DashboardViewController: UIViewController {
    var dashboardView: DashboardView!
    let dashboardViewModel = DashboardViewModel()
    var disposalbleBag = Set<AnyCancellable>()
    var bannerAdData: BannerAdData?
    var restaurantData: RestaurantData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupAddTarget()
        setBindings()
    }
    
    override func loadView() {
        super.loadView()
        dashboardView = DashboardView(frame: self.view.frame)
        self.view = dashboardView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dashboardViewModel.getShortcutButtonData()
        self.dashboardViewModel.getBannerAdData()
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
        // 식당 추천
        dashboardView.restaurantRecommendationsButton.addTarget(self, action: #selector(tappedRestaurantRecommendationsButton), for: .touchUpInside)
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
    
    func openInExBrowser(link: String) {
        if let url = URL(string: link) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func tappedBannerAd(sender: UIImageView) {
        guard let unwrappedBannerAdData = bannerAdData else { return }
        if unwrappedBannerAdData.is_external_browser {
            openInExBrowser(link: unwrappedBannerAdData.direction_url)
        } else {
            openInSafari(link: unwrappedBannerAdData.direction_url)
        }
    }
    
    @objc func tappedRestaurantRecommendationsButton(sender: UIButton) {
        self.view.makeToastActivity(.center)
        self.dashboardViewModel.getRestaurantData()
    }
}

extension DashboardViewController {
    fileprivate func setBindings() {
        print("DashboardViewController - setBindings()")
        self.dashboardViewModel.$shortcutButtonList.sink { (shortcutButtonList: [ShortcutButton]) in
            self.setShortcutButton(shortcutButtonList: shortcutButtonList)
        }.store(in: &disposalbleBag)
        
        self.dashboardViewModel.$bannerAdData.sink { bannerAdData in
            guard let unwrappedBannerAdData = bannerAdData else { return }
            self.setBannerAd(bannerAdData: unwrappedBannerAdData)
        }.store(in: &disposalbleBag)
        
        self.dashboardViewModel.$restaurantData.dropFirst().sink { restaurantData in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
            }
            guard let unwrappedRestaurantData = restaurantData else {
                DispatchQueue.main.async {
                    self.view.makeToast("😵 추천에 실패했어요", duration: 2.0)
                }
                return
            }
            self.showRestaurant(restaurantData: unwrappedRestaurantData)
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
        self.dashboardView.shortcutButtonStackView.removeAllArrangedSubviewsExceptFirst()
        for i in stride(from: 0, to: shortcutButtons.count, by: 4) {
            self.dashboardView.shortcutButtonStackView.addArrangedSubview(
                ShortcutRowStackView([shortcutButtons[i], shortcutButtons[i+1], shortcutButtons[i+2], shortcutButtons[i+3]])
            )
        }
    }
    
    func setBannerAd(bannerAdData: BannerAdData) {
        self.bannerAdData = bannerAdData
        DispatchQueue.main.async {
            self.dashboardView.adImageView.kf.setImage(with: URL(string: bannerAdData.image_url))
            self.dashboardView.adImageView.backgroundColor = .systemBackground
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedBannerAd))
            self.dashboardView.adImageView.addGestureRecognizer(tapGesture)
        }
    }
    
    func showRestaurant(restaurantData: RestaurantData) {
        let message = "\(restaurantData.name)\n(\(restaurantData.type))"
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "음식점 랜덤 추천", message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "지도 이동", style: .default) { _ in
                self.openInExBrowser(link: restaurantData.naver_map_url)
            }
            let cancle = UIAlertAction(title: "닫기", style: .destructive, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancle)
            
            if let vc = UIApplication.shared.windows.first?.visibleViewController {
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }
}
