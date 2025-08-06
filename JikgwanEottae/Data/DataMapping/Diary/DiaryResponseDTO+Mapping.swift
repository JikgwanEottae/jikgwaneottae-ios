//
//  DiaryResponseDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/2/25.
//

import Foundation

struct DiaryResponseDTO: Decodable {
    let result: Bool
    let httpCode: Int
    let data: [DiaryDTO]
    let message: String
}

extension DiaryResponseDTO {
    func toDomain() -> [Diary] {
        return data.map { $0.toDomain() }
    }
}
