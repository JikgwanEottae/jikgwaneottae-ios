//
//  KBOGameDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/6/25.
//

import Foundation

struct KBOGameDTO: Decodable {
    let id: Int
    let gameDate: String
    let gameTime: String
    let homeTeam: String
    let awayTeam: String
    let stadium: String
    let note: String?
    let homeScore: Int?
    let awayScore: Int?
    let status: String
    let winTeam: String?
}

extension KBOGameDTO {
    func toDomain() -> KBOGame {
        return KBOGame(
            id: id,
            gameDate: gameDate,
            gameTime: gameTime,
            ballpark: stadium,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            homeScore: homeScore,
            awayScore: awayScore,
            note: note,
            status: status
        )
    }
}
