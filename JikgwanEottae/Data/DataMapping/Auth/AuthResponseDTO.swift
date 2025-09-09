//
//  AuthResponseDTO.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/9/25.
//

import Foundation

struct AuthResponseDTO: Decodable {
    let result: Bool
    let httpCode: Int
    let data: AuthDataDTO?
    let message: String
}

extension AuthResponseDTO {
    struct AuthDataDTO: Decodable {
        let nickname: String?
        let isProfileCompleted: Bool?
        let profileImageURL: String?
        let accessToken: String?
        let refreshToken: String?
        
        private enum CodingKeys: String, CodingKey {
            case nickname
            case isProfileCompleted = "profileCompleted"
            case profileImageURL = "profileImageUrl"
            case accessToken
            case refreshToken
        }
    }
}
