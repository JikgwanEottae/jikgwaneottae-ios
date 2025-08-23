//
//  TourType.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/23/25.
//

import Foundation

// MARK: - 관광 타입 ID입니다.

enum TourType: String, Decodable, CaseIterable {
    case touristSpot = "12" // 관광지
    case culturalFacility = "14" // 문화시설
    case festival = "15" // 축제 공연 행사
    case travelCourse = "25" // 여행
    case sports = "28" // 레저
    case accommodation = "32" // 숙박
    case shopping = "38" // 쇼핑
    case restaurant = "39" // 식당
    
    var description: String {
        switch self {
        case .touristSpot:
            return "관광지"
        case .culturalFacility:
            return "문화시설"
        case .festival:
            return "행사"
        case .travelCourse:
            return "여행"
        case .sports:
            return "레저"
        case .accommodation:
            return "숙박"
        case .shopping:
            return "쇼핑"
        case .restaurant:
            return "식당"
        }
    }
}
