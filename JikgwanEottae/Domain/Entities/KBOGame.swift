//
//  Game.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/25/25.
//

import Foundation

// MARK: - KBO 경기 정보 엔티티

struct KBOGame: Hashable, Identifiable {
    typealias Identifier = Int
    let id: Identifier
    let gameDate: String
    let gameTime: String
    let ballpark: String
    let homeTeam: String
    let awayTeam: String
    let homeScore: Int?
    let awayScore: Int?
    let note: String?
    let status: String
}
