//
//  KBOGameResponseDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/6/25.
//

import Foundation

struct KBOGameResponseDTO: Decodable {
    let result: Bool
    let httpCode: Int
    let data: [KBOGameDTO]
    let message: String
}

extension KBOGameResponseDTO {
    func toDomain() -> [KBOGame]  {
        return data.map { $0.toDomain() }
    }
}
