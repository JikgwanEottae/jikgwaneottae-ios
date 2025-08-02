//
//  Diary.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/2/25.
//

import Foundation

// MARK: - 직관 기록 엔티티

struct Diary: Equatable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let gameDate: Date
    let gameTime: String
    let ballpark: String
    let homeTeam: String
    let awayTeam: String
    let homeScore: Int
    let awayscore: Int
    let favoriteTeam: String
    let seat: String?
    let memo: String?
    let imageURL: String?
}
