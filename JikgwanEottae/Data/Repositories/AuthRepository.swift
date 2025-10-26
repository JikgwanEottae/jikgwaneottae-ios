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
    private let diaryCacheManager = DiaryCache.shared
    
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
            authorizationCode: authorizationCode
        )
        .do(onSuccess: { [weak self] responseDTO in
            try self?.saveAuthenticationData(from: responseDTO)
        })
        .asCompletable()
    }
    
    public func validateRefreshToken(_ refreshToken: String) -> Completable {
        return networkManager.validateRefreshToken(refreshToken)
            .do(onSuccess: { [weak self] responseDTO in
                try self?.saveAuthenticationData(from: responseDTO)
            })
            .asCompletable()
    }
    
    public func setProfileNickname(_ nickname: String) -> Completable {
        return networkManager.setProfileNickname(nickname: nickname)
            .do(onCompleted: { [weak self]  in
                self?.saveProfileNickname(with: nickname)
            })
    }
    
    public func updateProfileImage(
        isImageRemoved: Bool,
        imageData: Data?
    ) -> Completable {
        return networkManager.updateProfileImage(
            isImageRemoved: isImageRemoved,
            imageData: imageData
        )
        .do(onSuccess: { [weak self] responseDTO in
            self?.saveProfileImageURL(from: responseDTO)
        })
        .asCompletable()
    }
    
    public func updateFavoriteTeam(
        team: String
    ) -> Completable {
        return networkManager.updateFavoriteTeam(team: team)
            .do(onCompleted: { [weak self]  in
                self?.saveFavoriteTeam(with: team)
            })
    }
    
    public func signOut() -> Completable {
        return networkManager.signOut()
            .do(onError: { [weak self] _ in
                self?.clearUserData()
            }, onCompleted: { [weak self]  in
                self?.clearUserData()
            })
    }
    
    public func withdrawAccount() -> Completable {
        return networkManager.withdrawAccount()
            .do(onError: { [weak self] _ in
                self?.clearUserData()
            }, onCompleted: { [weak self]  in
                self?.clearUserData()
            })
    }
}

extension AuthRepository {
    /// 인증에 성공하여 사용자 데이터 상태를 저장합니다.
    private func saveAuthenticationData(from responseDTO: AuthResponseDTO) throws {
        guard let data = responseDTO.data,
              let accessToken = data.accessToken,
              let refreshToken = data.refreshToken
        else {
            throw AuthError.invalidResponse
        }
        AppState.shared.isGuestMode = false
        AppState.shared.needsStatisticsRefresh = true
        AppState.shared.needsDiaryRefresh = true
        try KeychainManager.shared.saveAccessToken(accessToken)
        try KeychainManager.shared.saveRefreshToken(refreshToken)
        UserDefaultsManager.shared.nickname = data.nickname
        UserDefaultsManager.shared.favoriteTeam = data.favoriteTeam
        UserDefaultsManager.shared.profileImageURL = data.profileImageURL
    }
    
    /// 사용자의 프로필 이미지를 저장합니다.
    private func saveProfileImageURL(from responseDTO: AuthResponseDTO) {
        UserDefaultsManager.shared.profileImageURL = responseDTO.data?.profileImageURL
    }
    
    /// 사용자 닉네임 상태를 저장합니다.
    private func saveProfileNickname(with nickname: String) {
        UserDefaultsManager.shared.nickname = nickname
    }
    
    /// 사용자의 응원 구단을 저장합니다.
    private func saveFavoriteTeam(with favoriteTeam: String) {
        UserDefaultsManager.shared.favoriteTeam = favoriteTeam
    }
    
    /// 사용자의 모든 토큰과 데이터를 제거하고 상태를 초기화합니다.
    private func clearUserData() {
        try? KeychainManager.shared.deleteAllTokens()
        UserDefaultsManager.shared.clearAllKeys()
        AppState.shared.clear()
        diaryCacheManager.clear()
    }
}
