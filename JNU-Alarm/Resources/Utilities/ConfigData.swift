//
//  ConfigData.swift
//  JNU-Alarm
//
//  Created by 우진 on 3/1/24.
//

import Foundation

class ConfigData {
    class func get(topic: String) -> Bool {
        return UserDefaults.standard.bool(forKey: topic)
    }
    
    class func set(isOn: Bool, topic: String) {
        UserDefaults.standard.set(isOn, forKey: topic)
        print("\(topic)이 \(isOn)으로 설정됨.")
        
        guard var notiData: [String] = UserDefaults.standard.array(forKey: "notifications") as? [String] else {return}
        
        if isOn {
            notiData.append(topic)
        } else {
            guard let idx = notiData.firstIndex(of: topic) else {return}
            notiData.remove(at: idx)
        }
        UserDefaults.standard.set(notiData, forKey: "notifications")
        print("알림 내역 설정 상태 : \(String(describing: UserDefaults.standard.array(forKey: "notifications")))")
    }
}
