//
//  ContainerViewController.swift
//  JNU-Alarm
//
//  Created by 우진 on 3/2/24.
//

import UIKit
import GoogleMobileAds
import FirebaseMessaging

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
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        latestVersionCheck()
        subscribeDefaultTopic()
        unsubscribeLegacyTopic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ContainerViewController - viewWillApper()")
    }
    
    @objc func willEnterForeground() {
        if !NetworkMonitor.shared.isConnected {
            Alert.showAlertAndExit(title: "네트워크 연결 오류", message: "인터넷에 연결되어 있지 않습니다. 앱을 종료합니다.")
        }
        
        latestVersionCheck()
    }
    
    func latestVersionCheck() {
        VersionCheck.checkLatestVersion { latestVersion in
            // completion 핸들러 내에서 최신 버전을 받아와 처리합니다.
            if let latestVersion = latestVersion {
                guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else{return}
                print("HistoryViewController - latestVersionCheck(): 현재 버전: \(currentVersion)")
                print("HistoryViewController - latestVersionCheck(): 최신 버전: \(latestVersion)")
                let splitedCurrentVersion = currentVersion.split(separator: ".")
                let splitedLatestVersion = latestVersion.split(separator: ".")
//                let splitedCurrentVersion = ["1", "0", "2"] // 테스트용
//                let splitedLatestVersion = ["1", "0", "3"] // 테스트용
                print(splitedCurrentVersion)
                print(splitedLatestVersion)
                
                if splitedLatestVersion[0] > splitedCurrentVersion[0] {
                    // 강제 업데이트 대상 알림
                    DispatchQueue.main.async {
                        Alert.showForceUpdateAlert()
                    }
                } else if splitedLatestVersion[1] > splitedCurrentVersion[1] {
                    // 강제 업데이트 대상 알림
                    DispatchQueue.main.async {
                        Alert.showForceUpdateAlert()
                    }
                } else if splitedLatestVersion[2] > splitedCurrentVersion[2] {
                    // 권장 업데이트 대상 알림
                    if let lastShownDateString = UserDefaults.standard.string(forKey: "RUpdateAlertLastShownDate") {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        guard let lastShownDate = dateFormatter.date(from: lastShownDateString) else {
                            print("날짜 데이터 가져오기 오류")
                            return
                        }
                        print("지난 날짜 데이터 있음")
                        let calendar = Calendar.current
                        if !calendar.isDateInToday(lastShownDate) {
                            // 오늘 권장 업데이트 '다음에'를 선택 안 한 경우, 알림을 표시합니다.
                            DispatchQueue.main.async {
                                Alert.showRecommendUpdateAlert()
                            }
                        }
                        
                    } else {
                        print("지난 날짜 데이터 없음")
                        DispatchQueue.main.async {
                            Alert.showRecommendUpdateAlert()
                        }
                    }
                }
            } else {
                print("최신 버전 정보를 가져오는데 문제가 발생했습니다.")
            }
        }
    }
}

extension ContainerViewController {
    // 기본 topic 구독
    func subscribeDefaultTopic() {
        let defaultTopics = ["basic", "ios"]
        for topic in defaultTopics {
            if !UserDefaults.standard.bool(forKey: topic) {
                Messaging.messaging().subscribe(toTopic: topic) { error in
                    if let error = error {
                        print("Error subscribe: \(error)")
                      } else {
                          print("Subscribed to basic topic")
                          ConfigData.set(isOn: true, topic: topic)
                      }
                }
            }
        }
    }
    
    // 서비스 종료 알림 토픽 구독 취소 처리
    func unsubscribeLegacyTopic() {
        let legacyTopic = ["emergency"]
        for topic in legacyTopic {
            if UserDefaults.standard.bool(forKey: topic) {
                Messaging.messaging().unsubscribe(fromTopic: topic) { error in
                    if let error = error {
                        print("Error unsubscribe: \(error)")
                      } else {
                          print("Unsubscribed to \(topic) topic")
                          ConfigData.set(isOn: false, topic: topic)
                      }
                }
            }
            
        }
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

