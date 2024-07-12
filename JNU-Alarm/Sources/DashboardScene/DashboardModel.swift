//
//  DashboardModel.swift
//  JNU-Alarm
//
//  Created by 우진 on 7/11/24.
//

struct ShortcutResponseData: Codable {
    let success: Bool
    let response: [ShortcutData]
    let error: String?
}

struct ShortcutData: Codable {
    let name: String
    let ios_image_name: String
    let color_code: String
    let link: String
    let is_webview: Bool
    let is_modal: Bool
}

struct BannerAdResponseData: Codable {
    let success: Bool
    let response: BannerAdData
    let error: String?
}

struct BannerAdData: Codable {
    let image_url: String
    let direction_url: String
}

struct RestaurantRecommendationResponseData: Codable {
    let success: Bool
    let response: RestaurantData
    let error: String?
}

struct RestaurantData: Codable {
    let name: String
    let type: String
    let naver_map_url: String
}
