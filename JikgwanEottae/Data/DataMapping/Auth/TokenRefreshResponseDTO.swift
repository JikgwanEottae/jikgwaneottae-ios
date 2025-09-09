//
//  TokenRefreshDTO.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/9/25.
//

import Foundation

struct TokenRefreshResponseDTO: Decodable {
    let result: Bool
    let httpCode: Int
    let data: TokenRefreshDataDTO
    let message: String
}

extension TokenRefreshResponseDTO {
    struct TokenRefreshDataDTO: Decodable {
        let accessToken: String
        
        private enum CodingKeys: String, CodingKey {
            case accessToken
        }
    }
}
