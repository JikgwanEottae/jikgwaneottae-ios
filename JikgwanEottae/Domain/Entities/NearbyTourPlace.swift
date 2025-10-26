//
//  TourAttractions.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import Foundation

// MARK: - 구단 주변 인기 연관 관광지

struct NearbyTourPlace: Equatable {
    let stadium: String
    let attractions: [Attraction]
}

struct Attraction: Equatable {
    let rank: Int
    let name: String
    let city: String
    let district: String
    let category: String
}
