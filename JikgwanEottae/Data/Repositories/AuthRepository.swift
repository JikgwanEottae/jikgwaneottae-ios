//
//  AuthRepository.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/6/25.
//

import Foundation

import RxSwift

final class AuthRepository: AuthRepositoryProtocol {
    private let networkManaer: AuthNetworkManager
    private let keychainManager: KeychainManager
    
    init(networkManaer: AuthNetworkManager, keychainManager: KeychainManager) {
        self.networkManaer = networkManaer
        self.keychainManager = keychainManager
    }
    
    public func authenticateWithKakao(accessToken: String) -> Completable {
        return networkManaer.authenticateWithKakao(accessToken: accessToken)
            .flatMapCompletable { [weak self] authToken in
                Completable.create { completable in
                    do {
                        try self?.saveAuthenticationTokens(authToken)
                        completable(.completed)
                    } catch {
                        completable(.error(error))
                    }
                    return Disposables.create()
                }
            }
    }
    
    public func authenticateWithApple(
        identityToken: String,
        authorizationCode: String
    ) -> Completable {
        return networkManaer.authenticateWithApple(
            identityToken: identityToken,
            authorizationCode: authorizationCode
        ).flatMapCompletable { [weak self] authToken in
            Completable.create { completable in
                do {
                    try self?.saveAuthenticationTokens(authToken)
                    completable(.completed)
                } catch {
                    completable(.error(error))
                }
                return Disposables.create()
            }
        }
    }
}

extension AuthRepository {
    /// 키체인에 토큰을 저장합니다.
    private func saveAuthenticationTokens(_ authToken: AuthToken) throws {
        try self.keychainManager.saveAccessToken(authToken.accessToken)
        try self.keychainManager.saveRefreshToken(authToken.refreshToken)
    }
}
