//
//  DashboardViewModel.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/11/24.
//

import UIKit
import Combine

class DashboardViewModel: ObservableObject {
    
    @Published var shortcutButtonList = [ShortcutButton]()
    @Published var bannerAdData: BannerAdData?
    
    init() {
        print("DashboardViewModel - init()")
    }
    
    func getShortcutButtonData() {
        print("DashboardViewModel - getShortcutButtonData()")
        
        fetchShortcuts { shortcuts in
            DispatchQueue.main.async {
                if let shortcuts = shortcuts {
                    var tempArray: [ShortcutButton] = []
                    for shortcut in shortcuts {
                        tempArray.append(ShortcutButton(name: shortcut.name, imageNmae: shortcut.ios_image_name, imageColor: UIColor(hexCode: shortcut.color_code), link: shortcut.link, isModal: shortcut.is_modal))
                    }
                    self.shortcutButtonList = tempArray
                } else {
                    print("바로가기 데이터 가져오기 실패")
                }
            }
        }
    }
    
    func fetchShortcuts(completion: @escaping ([ShortcutData]?) -> Void) {
        let session = URLSession.shared
        
        let url = URL(string: Bundle.main.getSecret(name: "SHORTCUT_API_URL"))!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else if let data = data {
                if let responseData = try? JSONDecoder().decode(ShortcutResponseData.self, from: data) {
                    completion(responseData.response)
                } else {
                    print("Error: Unable to get response data")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func getBannerAdData() {
        print("DashboardViewModel - getBannerAdData()")
        
        fetchBannerAd { bannerAd in
            if let bannerAd = bannerAd {
                self.bannerAdData = bannerAd
            } else {
                print("배너 광고 데이터 가져오기 실패")
            }
        }
    }
    
    func fetchBannerAd(completion: @escaping (BannerAdData?) -> Void) {
        let session = URLSession.shared
        
        let url = URL(string: Bundle.main.getSecret(name: "BANNER_AD_API_URL"))!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else if let data = data {
                if let responseData = try? JSONDecoder().decode(BannerAdResponseData.self, from: data) {
                    completion(responseData.response)
                } else {
                    print("Error: Unable to get response data")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}
