//
//  Record.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/25/25.
//

import Foundation

// MARK: - 직관 기록 엔티티

struct BaseBallRecord: Equatable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let date: String
    let time: String
    let ballpark: String
    let homeTeam: KBOTeam
    let awayTeam: KBOTeam
    let homeScore: Int
    let awayScore: Int
    let seat: String?
    let memo: String?
    let imageURL: String?
}
