//
//  DiaryResponseDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/2/25.
//

import Foundation

struct DiaryResponseDTO: Decodable {
    let result: Bool
    let httpCode: Int
    let data: [DiaryDataDTO]
    let message: String
}

extension DiaryResponseDTO {
    struct DiaryDataDTO: Decodable {
        let id: Int
        let gameDate: String
        let gameTime: String
        let homeScore: Int
        let awayScore: Int
        let winTeam: String?
        let favoriteTeam: String
        let title: String
        let homeTeam: String
        let awayTeam: String
        let result: String?
        let ballpark: String
        let seat: String
        let memo: String
        let content: String
        let imageURL: String?
        
        private enum CodingKeys: String, CodingKey {
            case id = "diaryId"
            case gameDate = "date"
            case gameTime
            case homeScore
            case awayScore
            case winTeam
            case favoriteTeam
            case title
            case homeTeam
            case awayTeam
            case result
            case ballpark = "stadium"
            case seat
            case memo
            case content
            case imageURL = "photoUrl"
        }
    }
}

extension DiaryResponseDTO {
    func toDomain() -> [Diary] {
        return data.map { $0.toDomain() }
    }
}

extension DiaryResponseDTO.DiaryDataDTO {
    func toDomain() -> Diary {
        return Diary(
            id: id,
            gameDate: gameDate,
            gameTime: gameTime,
            ballpark: ballpark,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            homeScore: homeScore,
            awayScore: awayScore,
            favoriteTeam: favoriteTeam,
            title: title,
            result: result,
            seat: seat,
            memo: memo,
            content: content,
            imageURL: imageURL
        )
    }
}
