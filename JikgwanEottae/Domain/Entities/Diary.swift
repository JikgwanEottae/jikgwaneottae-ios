//
//  Diary.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/2/25.
//

import Foundation

// MARK: - 직관 기록 엔티티

struct Diary: Hashable, Identifiable {
    typealias Identifier = Int
    let id: Identifier
    let gameDate: String
    let gameTime: String
    let ballpark: String
    let homeTeam: String
    let awayTeam: String
    let homeScore: Int
    let awayScore: Int
    let favoriteTeam: String
    let result: String?
    let seat: String?
    let memo: String?
    let imageURL: String?
}

