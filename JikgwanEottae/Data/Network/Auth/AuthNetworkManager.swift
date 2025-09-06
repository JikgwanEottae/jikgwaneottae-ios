//
//  AuthNetworkManager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/5/25.
//

import Foundation

import Moya
import RxSwift

final class AuthNetworkManager {
    static let shared = AuthNetworkManager()
    private let provider = MoyaProvider<AuthAPIService>()
    
    private init() { }
    
    public func authenticateWithKakao(accessToken: String) -> Single<AuthToken> {
        return self.provider.rx.request(.authenticateWithKakao(accessToken: accessToken))
            .map(AuthResponseDTO.self)
            .map { $0.toDomain() }
    }
    
    public func authenticateWithApple(
        identityToken: String,
        authorizationCode: String
    ) -> Single<AuthToken> {
        return self.provider.rx.request(.authenticateWithApple(identityToken: identityToken, authorizationCode: authorizationCode))
            .map(AuthResponseDTO.self)
            .map { $0.toDomain() }
    }
}
