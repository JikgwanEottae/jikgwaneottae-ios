//
//  Stats.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/2/25.
//

import Foundation

struct Stats: Equatable, Identifiable {
    typealias Identifier = Int
    let id: Identifier
    let wins: Int
    let losses: Int
    let draws: Int
    let winningRate: Int
}

