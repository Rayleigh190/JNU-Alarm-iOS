//
//  VersionCheck.swift
//  JNU-Alarm
//
//  Created by 우진 on 4/18/24.
//

import Foundation
import UIKit

class VersionCheck {
    class func checkLatestVersion(completion: @escaping (String?) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: Bundle.main.getSecret(name: "APP_INFO_API_URL")) else {
            print("Error: Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else if let data = data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let responseData = responseJSON?["response"] as? [String: Any], 
                        let iosLatestVersion = responseData["ios_latest_version"] as? String,
                        let isAvailable = responseData["is_available"] as? Bool {
                        if isAvailable { completion(iosLatestVersion) }
                        else { completion(nil) }
                    } else {
                        print("Error: Unable to parse response data")
                        completion(nil)
                    }
                } catch {
                    print("Error: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}
