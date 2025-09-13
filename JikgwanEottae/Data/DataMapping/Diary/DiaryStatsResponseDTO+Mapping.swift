//
//  DiaryStatsResponseDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/3/25.
//

import Foundation

struct DiaryStatsResponseDTO: Decodable {
    let result: Bool
    let httpCode: Int
    let data: DiaryStatsDataDTO
    let message: String
}

extension DiaryStatsResponseDTO {
    struct DiaryStatsDataDTO: Decodable {
        let userID: Int
        let wins: Int
        let losses: Int
        let draws: Int
        let winRate: Float
        
        private enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case wins = "winCount"
            case losses = "lossCount"
            case draws = "drawCount"
            case winRate
        }
    }
}

extension DiaryStatsResponseDTO {
    func toDomain() -> DiaryStats {
        return data.toDomain()
    }
}

extension DiaryStatsResponseDTO.DiaryStatsDataDTO {
    func toDomain() -> DiaryStats {
        return DiaryStats(
            wins: wins,
            losses: losses,
            draws: draws,
            winRate: winRate
        )
    }
}

