//
//  TourType.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/23/25.
//

import Foundation

// MARK: - 관광 타입입니다.

enum TourType: String, CaseIterable {
    case restaurant = "음식점"
    case shopping = "쇼핑"
    case touristSpot = "관광지"
    case culturalFacility = "문화시설"
    case festival = "행사"
    case travelCourse = "여행"
    case sports = "레저"
    case accommodation = "숙박"
}
