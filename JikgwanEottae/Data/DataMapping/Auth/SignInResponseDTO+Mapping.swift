//
//  SignInResponseDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/5/25.
//

import Foundation

struct SignInResponseDTO: Decodable {
    let result: Bool
    let httpCode: Int
    let data: SignInDataDTO
    let message: String
}

extension SignInResponseDTO {
    struct SignInDataDTO: Decodable {
        let nickname: String
        let profileImageURL: String?
        let isProfileCompleted: Bool
        let accessToken: String
        let refreshToken: String
        
        private enum CodingKeys: String, CodingKey {
            case nickname
            case profileImageURL = "profileImageUrl"
            case isProfileCompleted = "profileCompleted"
            case accessToken
            case refreshToken
        }
    }
}
