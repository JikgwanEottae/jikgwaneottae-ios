//
//  AuthRepository.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/6/25.
//

import Foundation

import RxSwift

final class AuthRepository: AuthRepositoryProtocol {
    private let networkManager: AuthNetworkManager
    
    init(networkManaer: AuthNetworkManager) {
        self.networkManager = networkManaer
    }
    
    public func authenticateWithKakao(accessToken: String) -> Completable {
        return networkManager.authenticateWithKakao(accessToken: accessToken)
            .do(onSuccess: { [weak self] responseDTO in
                try self?.saveAuthenticationData(from: responseDTO)
            })
            .asCompletable()
    }
    
    public func authenticateWithApple(
        identityToken: String,
        authorizationCode: String
    ) -> Completable {
        return networkManager.authenticateWithApple(
            identityToken: identityToken,
            authorizationCode: authorizationCode)
        .flatMapCompletable { responseDTO in
            return Completable.create { completable in
                do {
                    let accessToken = responseDTO.data.accessToken
                    let refreshToken = responseDTO.data.refreshToken
                    // 발급받은 액세스 토큰과 리프레쉬 토큰을 저장합니다.
                    try KeychainManager.shared.saveAccessToken(accessToken)
                    try KeychainManager.shared.saveRefreshToken(refreshToken)
                    // 프로필 설정 유무를 저장합니다.
                    UserDefaultsManager.shared.isProfileCompleted = responseDTO.data.isProfileCompleted
                    // 닉네임을 저장합니다.
                    UserDefaultsManager.shared.nickname = responseDTO.data.nickname
                    completable(.completed)
                } catch {
                    completable(.error(error))
                }
                return Disposables.create()
            }
        }
    }
    
    public func validateRefreshToken(_ refreshToken: String) -> Completable {
        return networkManager.validateRefreshToken(refreshToken)
            .flatMapCompletable { responseDTO in
                return Completable.create { completable in
                    do {
                        let accessToken = responseDTO.data.accessToken
                        try KeychainManager.shared.saveAccessToken(accessToken)
                        completable(.completed)
                    } catch {
                        completable(.error(error))
                    }
                    return Disposables.create()
                }
            }
    }
    
    public func setProfileNickname(_ nickname: String) -> Completable {
        return networkManager.setProfileNickname(nickname: nickname)
    }
    
    public func signOut() -> Completable {
        return networkManager.signOut()
            .do(onError: { [weak self] _ in
                self?.clearUserData()
            }, onCompleted: { [weak self]  in
                self?.clearUserData()
            })
    }
}

extension AuthRepository {
    /// 인증에 성공하여 사용자 데이터를 저장합니다.
    private func saveAuthenticationData(from responseDTO: AuthResponseDTO) throws {
        guard let data = responseDTO.data,
              let accessToken = data.accessToken,
              let refreshToken = data.refreshToken
        else {
            throw AuthError.invalidResponse
        }
        try KeychainManager.shared.saveAccessToken(accessToken)
        try KeychainManager.shared.saveRefreshToken(refreshToken)
        UserDefaultsManager.shared.nickname = data.nickname
        UserDefaultsManager.shared.isProfileCompleted = data.isProfileCompleted ?? false
        UserDefaultsManager.shared.profileImageURL = data.profileImageURL
    }
    
    /// 사용자의 모든 토큰과 데이터를 제거합니다.
    private func clearUserData() {
        try? KeychainManager.shared.deleteAllTokens()
        UserDefaultsManager.shared.clearAllKeys()
    }
}
