//
//  Game.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/25/25.
//

import Foundation

// MARK: - 야구 경기 정보

struct Baseball: Equatable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let date: String
    let time: String
    let ballpark: String
    let homeTeam: KBOTeam
    let awayTeam: KBOTeam
    let homeScore: Int
    let awayScore: Int
}
