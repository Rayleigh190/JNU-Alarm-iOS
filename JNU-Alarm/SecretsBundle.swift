//
//  SecretsBundle.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/23/24.
//

import Foundation

extension Bundle {
    
    func getSecret(name: String) -> String {
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else{return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource[name] as? String else {fatalError("\(name) error")}
        return key
    }
    
    var NOTIFICATIONS_API_URL: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist") else{return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["NOTIFICATIONS_API_URL"] as? String else {fatalError("NOTIFICATIONS_API_URL error")}
        return key
    }
    
}
