//
//  TodayFortuneResponseDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/3/25.
//

import Foundation

struct TodayFortuneResponseDTO: Decodable {
    let result: Bool
    let httpCode: Int
    let data: TodayFortuneDataDTO
    let message: String
}

extension TodayFortuneResponseDTO {
    struct TodayFortuneDataDTO: Decodable {
        let score: Double
        let recommendation: String
        let compatibilityType: String
        let todayFortune: String
        let timeNote: String
        let favoriteTeam: String
        
        private enum CodingKeys: String, CodingKey {
            case score
            case recommendation
            case compatibilityType = "compatibility_type"
            case todayFortune = "today_fortune"
            case timeNote = "time_note"
            case favoriteTeam
        }
    }
}

extension TodayFortuneResponseDTO {
    func toDomain() -> Fortune {
        return data.toDomain()
    }
}

extension TodayFortuneResponseDTO.TodayFortuneDataDTO {
    func toDomain() -> Fortune {
        return Fortune(
            score: score,
            recommendation: recommendation,
            compatibility: compatibilityType,
            description: todayFortune,
            note: timeNote,
            favoriteTeam: favoriteTeam
        )
    }
}
