//
//  DiaryDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/2/25.
//

import Foundation

struct DiaryDTO: Decodable {
    let diaryId: Int
    let date: String
    let gameTime: String
    let homeScore: Int
    let awayScore: Int
    let winTeam: String
    let favoriteTeam: String
    let homeTeam: String
    let awayTeam: String
    let result: String
    let stadium: String
    let seat: String?
    let memo: String?
    let photoUrl: String?
}

extension DiaryDTO {
    func toDomain() -> Diary {
        Diary(
            id: diaryId,
            gameDate: date,
            gameTime: gameTime,
            ballpark: stadium,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            homeScore: homeScore,
            awayScore: awayScore,
            favoriteTeam: favoriteTeam,
            result: result,
            seat: seat,
            memo: memo,
            imageURL: photoUrl
        )
    }
}

