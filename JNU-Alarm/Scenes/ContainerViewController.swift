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
    
    private lazy var bannerView: GADBannerView = {
        bannerView = GADBannerView(adSize: adSizeType)
        bannerView.alpha = 0
        bannerView.delegate = self
        return bannerView
    }()
    
    private lazy var backgroundBannerView: UIView = {
        let view = UIView()
        
        let image = UIImageView(image: UIImage(named: "banner_1"))
        image.contentMode = .scaleAspectFit
        
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    
        setupSubViews()
        initAdMob()
        
        let childVC = MainTapBarController()
        childVC.view.frame = containerView.bounds
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.didMove(toParent: self)
        
        // 백그라운드 > 포그라운드 시 광고 로드
        NotificationCenter.default.addObserver(self, selector: #selector(loadAd), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

}

extension ContainerViewController {
    func initAdMob() {
        var adUnitID: String
        #if DEBUG
            adUnitID = "ca-app-pub-3940256099942544/2934735716" // test id
        #else
            adUnitID = "ca-app-pub-4183402691727093/5410662598" // service id
        #endif
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = self
        loadAd()
    }
    
    @objc func loadAd() {
        bannerView.load(GADRequest())
    }
    
    func setupSubViews() {
        view.addSubview(containerView)
        view.addSubview(backgroundBannerView)
        view.addSubview(bannerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: backgroundBannerView.topAnchor),
        ])
        
        backgroundBannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundBannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundBannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundBannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundBannerView.heightAnchor.constraint(equalToConstant: CGFloat(adHeight)),
        ])
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: backgroundBannerView.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: backgroundBannerView.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: backgroundBannerView.bottomAnchor),
            bannerView.topAnchor.constraint(equalTo: backgroundBannerView.topAnchor),
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

