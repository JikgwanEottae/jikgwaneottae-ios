//
//  TodayFortuneRequestDTO.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/3/25.
//

import Foundation

struct TodayFortuneRequestDTO: Encodable {
    let birth_date: String
    let time: Int?
    let gender: String
    let team_name: String
}

extension TodayFortuneRequestDTO {
    func toDictionary() -> [String: Any?] {
        return [
            "birth_date": birth_date,
            "time": time,
            "gender": gender,
            "team_name": team_name
        ]
    }
}
