//
//  TodayFortuneRequestDTO.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/3/25.
//

import Foundation

struct TodayFortuneRequestDTO: Encodable {
    let date: String
    let time: Int?
    let gender: String
    let favoriteTeam: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "birth_date"
        case time = "time"
        case gender = "gender"
        case favoriteTeam = "team_name"
    }
}
