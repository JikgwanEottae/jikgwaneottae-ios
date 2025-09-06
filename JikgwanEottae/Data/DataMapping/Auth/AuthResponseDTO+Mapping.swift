//
//  AuthResponseDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/5/25.
//

import Foundation

struct AuthResponseDTO: Decodable {
    let result: Bool
    let httpCode: Int
    let data: AuthTokenDTO
    let message: String
}

extension AuthResponseDTO {
    struct AuthTokenDTO: Decodable {
        let accessToken: String
        let refreshToken: String
        
        private enum CodingKeys: String, CodingKey {
            case accessToken
            case refreshToken
        }
    }
}

extension AuthResponseDTO {
    func toDomain() -> AuthToken {
        return data.toDomain()
    }
}

extension AuthResponseDTO.AuthTokenDTO {
    func toDomain() -> AuthToken {
        return AuthToken(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
