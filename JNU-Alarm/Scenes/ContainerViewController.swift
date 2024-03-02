//
//  ContainerViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 3/2/24.
//

import UIKit
import GoogleMobileAds

class ContainerViewController: UIViewController {
    
    private let adHeight: Float = {
        return 50
    }()
    
    private var adSizeType = {
        return GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.size.width, height: 50))
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        bannerView = GADBannerView(adSize: adSizeType)
        bannerView.alpha = 0
        bannerView?.delegate = self
    
        initAdMob()
        setupSubViews()
        
        let childVC = MainTapBarController()
        childVC.view.frame = containerView.bounds
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.didMove(toParent: self)
    }

}

extension ContainerViewController {
    func initAdMob() {
        guard let bannerView = bannerView else { return }
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test ID
        bannerView.rootViewController = self
        loadAd()
    }
    
    func loadAd() {
        guard let bannerView = bannerView else { return }
        bannerView.load(GADRequest())
    }
    
    func setupSubViews() {
        view.addSubview(containerView)
        view.addSubview(bannerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bannerView.topAnchor),
        ])
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: CGFloat(adHeight)),
        ])
    }
      
}

extension ContainerViewController : GADBannerViewDelegate {
    //로드 완료
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 1
        print("bannerViewDidReceiveAd")
    }
    // 로드 실패
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    // 노출 직전
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    // 닫히기 직전
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    // 닫힌 순간
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    //앱 백그라운드
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}

