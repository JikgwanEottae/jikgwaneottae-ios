//
//  AuthUseCase.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/6/25.
//

import Foundation

import RxSwift

protocol AuthUseCaseProtocol {
    func authenticateWithKakao(
        accessToken: String
    ) -> Completable
    
    func authenticateWithApple(
        identityToken: String,
        authorizationCode: String
    ) -> Completable
    
    func setProfileNickname(
        _ nickname: String
    ) -> Completable
    
    func updateProfileImage(
        isImageRemoved: Bool,
        imageData: Data?
    ) -> Completable
    
    func updateFavoriteTeam(
        team: String
    ) -> Completable
    
    func validateRefreshToken(
        _ refreshToken: String
    ) -> Completable
    
    func signOut() -> Completable
    
    func withdrawAccount() -> Completable
}

final class AuthUseCase: AuthUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    public func authenticateWithKakao(accessToken: String) -> Completable {
        return repository.authenticateWithKakao(accessToken: accessToken)
    }
    
    public func authenticateWithApple(
        identityToken: String,
        authorizationCode: String
    ) -> Completable {
        return repository.authenticateWithApple(
            identityToken: identityToken,
            authorizationCode: authorizationCode
        )
    }
    
    public func setProfileNickname(_ nickname: String) -> Completable {
        return repository.setProfileNickname(nickname)
    }
    
    public func updateProfileImage(
        isImageRemoved: Bool,
        imageData: Data?
    ) -> Completable {
        return repository.updateProfileImage(
            isImageRemoved: isImageRemoved,
            imageData: imageData
        )
    }
    
    public func updateFavoriteTeam(
        team: String
    ) -> Completable {
        return repository.updateFavoriteTeam(team: team)
    }
    
    public func validateRefreshToken(_ refreshToken: String) -> Completable {
        return repository.validateRefreshToken(refreshToken)
    }
    
    public func signOut() -> Completable {
        return repository.signOut()
    }
    
    public func withdrawAccount() -> Completable {
        return repository.withdrawAccount()
    }
}
