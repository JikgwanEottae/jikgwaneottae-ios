//
//  AuthAPIService.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/5/25.
//

import Foundation

import Moya

enum AuthAPIService {
    case authenticateWithKakao(accessToken: String)
    case authenticateWithApple(identityToken: String, authorizationCode: String)
}

extension AuthAPIService: TargetType {
    var baseURL: URL {
        URL(string: "https://api.jikgwaneottae.xyz")!
    }
    
    var path: String {
        switch self {
        case .authenticateWithKakao:
            return "/api/auth/login/kakao"
        case .authenticateWithApple:
            return "/api/auth/login/apple"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case .authenticateWithKakao(let accessToken):
            return .requestParameters(
                parameters: [
                    "accessToken": accessToken
                ],
                encoding: JSONEncoding.default)
        case .authenticateWithApple(let identityToken, let authorizationCode):
            return .requestParameters(
                parameters: [
                    "identityToken": identityToken,
                    "authorizationCode": authorizationCode
                ],
                encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
