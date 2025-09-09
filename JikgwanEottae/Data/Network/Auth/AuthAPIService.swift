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
    case setProfileNickname(nickname: String)
    case validateRefreshToken(_ refreshToken: String)
    case signOut
    case withdrawAccount
}

extension AuthAPIService: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        URL(string: "https://api.jikgwaneottae.xyz")!
    }
    
    var path: String {
        switch self {
        case .authenticateWithKakao:
            return "/api/auth/login/kakao"
        case .authenticateWithApple:
            return "/api/auth/login/apple"
        case .setProfileNickname:
            return "/api/auth/profile"
        case .validateRefreshToken:
            return "/api/auth/refresh"
        case .signOut:
            return "/api/auth/logout"
        case .withdrawAccount:
            return "/api/auth/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .withdrawAccount:
            return .delete
        default:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .authenticateWithKakao(let accessToken):
            return .requestParameters(
                parameters: ["accessToken": accessToken],
                encoding: JSONEncoding.default)
        case .authenticateWithApple(let identityToken, let authorizationCode):
            return .requestParameters(
                parameters: [
                    "identityToken": identityToken,
                    "authorizationCode": authorizationCode
                ],
                encoding: JSONEncoding.default
            )
        case .setProfileNickname(let nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: JSONEncoding.default
            )
        case .validateRefreshToken(let refreshToken):
            return .requestParameters(
                parameters: ["refreshToken": refreshToken],
                encoding: JSONEncoding.default
            )
        case .signOut:
            return .requestPlain
        case .withdrawAccount:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        case .setProfileNickname, .signOut, .withdrawAccount:
            return .bearer
        default:
            return nil
        }
    }
}
