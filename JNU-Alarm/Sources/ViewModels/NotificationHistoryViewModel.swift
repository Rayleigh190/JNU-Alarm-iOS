//
//  NotificationHistoryViewModel.swift
//  JNU-Alarm
//
//  Created by 우진 on 6/23/24.
//

import UIKit
import Combine

class NotificationHistoryViewModel: ObservableObject {
    
    @Published var notificationHistoryDataList = [NotificationHistoryData]()
    
    var numOfNotificationHistoryDataList: Int {
        return notificationHistoryDataList.count
    }
    
    init() {
        print("NotificationHistoryViewModel - init()")
    }
    
    func notificationHistoryData(at index: Int) -> NotificationHistoryData {
        return notificationHistoryDataList[index]
    }
    
    func dateFormatConversion(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy.MM.dd"
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
    
    func updateNotificationHistoryData() {
        print("NotificationHistoryViewModel - setNotificationData()")
        
        fetchNotifications { [weak self] notifications in
            guard let self = self else { return }
            
            if let notifications = notifications {
                var tempArray: [NotificationHistoryData] = []
                for notification in notifications {
                    tempArray.append(NotificationHistoryData(title: notification.title, body: notification.body, link: notification.link, created_at: dateFormatConversion(from: notification.created_at)))
                }
                self.notificationHistoryDataList = tempArray
            } else {
                print("알림 가져오기 실패")
            }
        }
    }
    
    func fetchNotifications(completion: @escaping ([NotificationHistoryData]?) -> Void) {
        // URL 세션을 생성합니다.
        let session = URLSession.shared
        
        // 요청할 URL을 정의합니다.
        let url = URL(string: Bundle.main.getSecret(name: "NOTIFICATIONS_API_URL"))!
        // POST할 데이터를 준비합니다.
        let postData = [
            "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "00000",
            "subscribed_topics": UserDefaults.standard.array(forKey: "notifications") ?? []
        ] as [String : Any]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: postData) else {
            print("Error: Unable to serialize JSON data")
            completion(nil)
            return
        }
        
        // URLRequest를 생성합니다.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        var notifications = [NotificationHistoryData]()
        // 데이터를 보낸 후 처리할 작업을 정의합니다.
        let task = session.dataTask(with: request) { data, response, error in
            // 응답을 처리합니다.
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else if let data = data {
                do {
                    // 응답 데이터를 파싱합니다.
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    // 응답 데이터에서 response 키의 값인 배열을 가져옵니다.
                    if let responseData = responseJSON?["response"] as? [[String: Any]] {
                        // 배열의 각 요소를 순회하면서 원하는 정보를 출력하거나 활용할 수 있습니다.
                        for data in responseData {
                            if let title = data["title"] as? String,
                                let body = data["body"] as? String,
                                let link = data["link"] as? String,
                                let createdAt = data["created_at"] as? String {
                                let article = NotificationHistoryData(title: title, body: body, link: link, created_at: createdAt)
                                notifications.append(article)
                            }
                        }
                        completion(notifications)
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
