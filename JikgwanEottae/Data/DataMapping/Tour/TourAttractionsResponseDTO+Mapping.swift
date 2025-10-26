//
//  TourAttractionsResponseDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import Foundation

// MARK: - 구단 주변 인기 연관 관광지 DTO

struct TourAttractionsResponseDTO: Decodable {
    let result: Bool
    let httpCode: Int
    let stadium: String
    let data: [AttractionDTO]
    let message: String
}

extension TourAttractionsResponseDTO {
    struct AttractionDTO: Decodable {
        let ranking: Int
        let attraction: String
        let city: String
        let district: String
        let category: String
    }
}

extension TourAttractionsResponseDTO {
    func toDomain() -> NearbyTourPlace {
        return NearbyTourPlace(
            stadium: stadium,
            attractions: data.map { $0.toDomain() }
        )
    }
}

extension TourAttractionsResponseDTO.AttractionDTO {
    func toDomain() -> Attraction {
        return Attraction(
            rank: ranking,
            name: attraction,
            city: city,
            district: district,
            category: category
        )
    }
}
