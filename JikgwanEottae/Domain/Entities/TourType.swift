//
//  TourType.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/23/25.
//

import Foundation

// MARK: - 관광 타입 ID입니다.

enum TourType: CaseIterable {
    case restaurant // 식당
    case shopping // 쇼핑
    case touristSpot // 관광지
    case culturalFacility // 문화시설
    case festival // 축제 공연 행사
    case travelCourse // 여행
    case sports // 레저
    case accommodation // 숙박
}

extension TourType {
    var description: String {
        switch self {
        case .restaurant:
            return "음식점"
        case .shopping:
            return "쇼핑"
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
        }
    }
}

extension TourType {
    var contentTypeId: String {
        switch self {
        case .restaurant:
            return "39"
        case .shopping:
            return "38"
        case .touristSpot:
            return "12"
        case .culturalFacility:
            return "14"
        case .festival:
            return "15"
        case .travelCourse:
            return "25"
        case .sports:
            return "28"
        case .accommodation:
            return "32"
        }
    }
}
