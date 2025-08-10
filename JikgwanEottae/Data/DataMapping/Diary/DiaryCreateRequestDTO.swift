//
//  DiaryCreateRequestDTO.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/10/25.
//

import Foundation


struct DiaryCreateRequestDTO: Encodable {
    let gameId: Int
    let favoriteTeam: String
    let seat: String?
    let memo: String?
}
