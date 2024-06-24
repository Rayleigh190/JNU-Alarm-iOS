//
//  NotificationHistory.swift
//  JNU-Alarm
//
//  Created by 우진 on 6/23/24.
//

struct NotificationHistoryResponseData: Codable {
    let success: Bool
    let response: [NotificationHistoryData]
    let error: String?
}

struct NotificationHistoryData: Codable {
    let title: String
    let body: String
    let link: String
    let created_at: String
}
