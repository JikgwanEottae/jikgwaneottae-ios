//
//  AuthError.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/10/25.
//

import Foundation

enum AuthError: Error {
    case invalidCredentials
    case invalidResponse
    case tokenExpired
    case keychainSaveFailure
    case networkFailure
    case userNotFound
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "인증 정보가 올바르지 않습니다."
        case .invalidResponse:
            return "서버 응답 데이터가 올바르지 않습니다."
        case .tokenExpired:
            return "토큰이 만료되었습니다."
        case .keychainSaveFailure:
            return "보안 저장소 접근에 실패했습니다."
        case .networkFailure:
            return "네트워크 연결을 확인해주세요."
        case .userNotFound:
            return "사용자를 찾을 수 없습니다."
        }
    }
}
